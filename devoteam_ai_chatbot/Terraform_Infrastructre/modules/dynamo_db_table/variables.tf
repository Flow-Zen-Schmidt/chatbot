variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "eu-central-1"
}

variable "table_name" {
  description = "The name of the DynamoDB table"
  default     = "ChatbotHistory"
}

variable "billing_mode" {
  description = "The billing mode for the DynamoDB table"
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "The hash key for the DynamoDB table"
  default     = "UserId"
}

variable "range_key" {
  description = "The range key for the DynamoDB table"
  default     = "Timestamp"
}

variable "environment" {
  description = "The environment (e.g., Production, Development)"
  default     = "DEV"
}