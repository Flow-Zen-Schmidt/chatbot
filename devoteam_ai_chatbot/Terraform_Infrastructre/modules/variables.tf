# variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-central-1"
}

variable "api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
}
variable "api_gateway_stage_name" {
  description = "Name of the API Gateway deployment stage"
  type        = string
  default     = "prod"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for chat history"
  type        = string
}

variable "lambda_role_name" {
  description = "Name of the IAM role for Lambda"
  type        = string
}

variable "lex_role_name" {
  description = "Name of the IAM role for Lex"
  type        = string
}

variable "lex_bot_name" {
  description = "Name of the Lex bot"
  type        = string
}

variable "lex_bot_alias_name" {
  description = "Name of the Lex bot alias"
  type        = string
}
