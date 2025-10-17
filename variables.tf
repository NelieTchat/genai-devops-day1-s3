variable "bucket_name" {
  description = "Explicit bucket name. If empty, one will be composed from prefix/env."
  type        = string
  default     = ""

  validation {
    condition     = var.bucket_name == "" || can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be 3–63 chars, lowercase letters, numbers, dots, or hyphens."
  }
}

variable "prefix" {
  description = "Name prefix for composed bucket (e.g., org or project)"
  type        = string
  default     = "nelie"
}

variable "env" {
  description = "Environment indicator"
  type        = string
  default     = "dev"

  validation {
    condition     = can(regex("^[a-z0-9-]{2,20}$", var.env))
    error_message = "env must be lowercase letters, numbers, or hyphens (2–20 chars)."
  }
}

variable "randomize" {
  description = "Append a short random suffix for uniqueness when composing name"
  type        = bool
  default     = true
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
