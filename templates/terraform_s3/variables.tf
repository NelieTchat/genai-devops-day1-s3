// -------- variables.tf --------
// Inputs kept explicit; no apply-time values.

variable "region" {
  type        = string
  description = "AWS region for the provider."
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket (must be globally unique)."
}

variable "kms_key_id" {
  type        = string
  description = "KMS key ARN or ID used for SSE-KMS on the bucket."
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
  default     = {}
}

variable "force_destroy" {
  type        = bool
  description = "Set to true to allow terraform to delete the bucket with objects/versions."
  default     = false
}
