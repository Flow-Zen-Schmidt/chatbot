# modules/api_gateway/variables.tf

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "api_description" {
  description = "Description of the API Gateway"
  type        = string
  default     = "Chatbot API Gateway"
}

variable "resource_path" {
  description = "Path part for the API resource"
  type        = string
  default     = "chat"
}

variable "http_method" {
  description = "HTTP method for the API"
  type        = string
  default     = "POST"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function"
  type        = string
}

variable "stage_name" {
  description = "Name of the deployment stage"
  type        = string
  default     = "prod"
}
