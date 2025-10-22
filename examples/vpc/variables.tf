variable "region" {
  type        = string
  description = "AWS region."
}
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
  default     = "10.42.0.0/16"
}
variable "public_subnet_cidr" {
  type        = string
  description = "Public subnet CIDR."
  default     = "10.42.0.0/24"
}
variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}
