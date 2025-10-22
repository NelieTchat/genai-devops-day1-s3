terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "pk"
  range_key = "sk"

  # Attributes used by table keys and GSI
  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "gpk"
    type = "S"
  }

  attribute {
    name = "gsk"
    type = "S"
  }

  # GSI example
  global_secondary_index {
    name            = "gsi1"
    hash_key        = "gpk"
    range_key       = "gsk"
    projection_type = "KEYS_ONLY"
  }

  # TTL on configurable attribute
  ttl {
    attribute_name = var.ttl_attribute
    enabled        = true
  }

  # Point-in-time recovery
  point_in_time_recovery {
    enabled = true
  }

  # Server-side encryption (AWS owned key by default)
  server_side_encryption {
    enabled = true
  }

  tags = var.tags
}
