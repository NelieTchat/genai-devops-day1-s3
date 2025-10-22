variable "region" {
  type        = string
  description = "AWS region."
}

variable "table_name" {
  type        = string
  description = "DynamoDB table name."
}

variable "ttl_attribute" {
  type        = string
  description = "TTL attribute name."
  default     = "ttl"
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}
