# modules/lambda/variables.tf

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_filename" {
  description = "Path to the Lambda deployment package"
  type        = string
  default     = "lambda_function.zip"
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "Lambda function runtime"
  type        = string
  default     = "python3.9"
}

variable "lambda_role_name" {
  description = "Name of the IAM role for Lambda"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
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
