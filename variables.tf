variable "bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ID or ARN for SSE-KMS encryption"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {
    Project = "GenAI-DevOps"
    Owner   = "Nelie"
  }
}
