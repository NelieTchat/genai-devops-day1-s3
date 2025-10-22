variable "region" {
  type        = string
  description = "AWS region."
}
variable "lt_name" {
  type        = string
  description = "Launch Template name."
  default     = "demo-lt"
}
variable "ami_id" {
  type        = string
  description = "AMI ID to reference (e.g., an Amazon Linux 2023 AMI)."
}
variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.micro"
}
variable "kms_key_id" {
  type        = string
  description = "KMS key ARN/ID for EBS encryption."
  default     = ""
}
variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}
