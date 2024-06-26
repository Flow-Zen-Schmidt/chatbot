# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
    # Change this to your preferred region
}

# Create an IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "chatbot_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Create a policy for DynamoDB access
resource "aws_iam_role_policy" "dynamodb_policy" {
  name = "dynamodb_access_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Effect = "Allow"
        Resource = "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/ChatbotHistory"
      }
    ]
  })
}


data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/./lambda_function.py"
  output_path = "lambda_function.zip"
}


# Create the Lambda function
resource "aws_lambda_function" "chatbot_lambda" {
  filename      = "lambda_function.zip"  # You need to create this zip file with your Lambda code
  function_name = "chatbot_handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  environment {
    variables = {
      DYNAMODB_TABLE = "ChatbotHistory"
    }
  }
}

# Data sources to get AWS account ID and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Output the Lambda function name
output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.chatbot_lambda.function_name
}

# Output the Lambda function ARN
output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.chatbot_lambda.arn
}

# Output the IAM role name
output "lambda_role_name" {
  description = "Name of the IAM role for Lambda"
  value       = aws_iam_role.lambda_role.name
}

# Output the IAM role ARN
output "lambda_role_arn" {
  description = "ARN of the IAM role for Lambda"
  value       = aws_iam_role.lambda_role.arn
}