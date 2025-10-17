terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6"
    }
  }
}

provider "aws" {
  region = var.region
}

# Optional random suffix (4 hex chars) for global uniqueness
resource "random_id" "suffix" {
  count       = var.randomize ? 1 : 0
  byte_length = 2
}

locals {
  # base like: nelie-dev-logs
  bucket_base = lower(replace("${var.prefix}-${var.env}-logs", "_", "-"))
  # final like: nelie-dev-logs-ab12 (if randomize) or just nelie-dev-logs
  bucket_comp = var.randomize ? "${local.bucket_base}-${random_id.suffix[0].hex}" : local.bucket_base

  # if user passes bucket_name, use it; otherwise, use composed name
  bucket_final = var.bucket_name != "" ? var.bucket_name : local.bucket_comp
}

# S3 bucket (private, versioned, KMS-encrypted)
resource "aws_s3_bucket" "logs" {
  bucket = local.bucket_final
  tags   = merge(var.tags, { Name = local.bucket_final })
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_id
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "noncurrent-transition-and-expire"
    status = "Enabled"

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = 180
    }
  }
}

# Extra guardrails via bucket policy (deny non-TLS + public ACLs)
resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid: "DenyInsecureTransport",
        Effect: "Deny",
        Principal: "*",
        Action: "s3:*",
        Resource: [
          aws_s3_bucket.logs.arn,
          "${aws_s3_bucket.logs.arn}/*"
        ],
        Condition: { Bool: { "aws:SecureTransport": "false" } }
      },
      {
        Sid: "DenyPublicAcls",
        Effect: "Deny",
        Principal: "*",
        Action: [ "s3:PutObject", "s3:PutObjectAcl" ],
        Resource: "${aws_s3_bucket.logs.arn}/*",
        Condition: {
          StringEquals: {
            "s3:x-amz-acl": [ "public-read", "public-read-write", "authenticated-read" ]
          }
        }
      }
    ]
  })
}

