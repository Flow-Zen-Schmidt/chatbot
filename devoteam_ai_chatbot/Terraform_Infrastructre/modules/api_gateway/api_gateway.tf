# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"  # Make sure this matches the region in your Lambda file
}

# Reference to existing Lambda function
resource "aws_lambda_function" "chatbot_lambda" {
  function_name = "chatbot_handler"
  # ... other attributes are defined in the Lambda file
}

# Reference to existing IAM role
resource "aws_iam_role" "lambda_role" {
  name = "chatbot_lambda_role"
  # ... other attributes are defined in the Lambda file
}

# Create API Gateway
resource "aws_api_gateway_rest_api" "chatbot_api" {
  name        = "chatbot-api"
  description = "Chatbot API"
}

# Create API Gateway resource
resource "aws_api_gateway_resource" "chatbot_resource" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  parent_id   = aws_api_gateway_rest_api.chatbot_api.root_resource_id
  path_part   = "chat"
}

# Create API Gateway POST method
resource "aws_api_gateway_method" "chatbot_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.chatbot_api.id
  resource_id   = aws_api_gateway_resource.chatbot_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Create API Gateway integration with Lambda
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  resource_id = aws_api_gateway_resource.chatbot_resource.id
  http_method = aws_api_gateway_method.chatbot_post_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.chatbot_lambda.invoke_arn
}

# Add CORS support
resource "aws_api_gateway_method" "chatbot_options_method" {
  rest_api_id   = aws_api_gateway_rest_api.chatbot_api.id
  resource_id   = aws_api_gateway_resource.chatbot_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "chatbot_options_200" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  resource_id = aws_api_gateway_resource.chatbot_resource.id
  http_method = aws_api_gateway_method.chatbot_options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "chatbot_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  resource_id = aws_api_gateway_resource.chatbot_resource.id
  http_method = aws_api_gateway_method.chatbot_options_method.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "chatbot_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  resource_id = aws_api_gateway_resource.chatbot_resource.id
  http_method = aws_api_gateway_method.chatbot_options_method.http_method
  status_code = aws_api_gateway_method_response.chatbot_options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# Deploy the API
resource "aws_api_gateway_deployment" "chatbot_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.chatbot_options_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  stage_name  = "prod"
}

# Allow API Gateway to invoke Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chatbot_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.chatbot_api.execution_arn}/*/*"
}

# Output the invoke URL
output "invoke_url" {
  description = "Invoke URL for API Gateway endpoint"
  value       = "${aws_api_gateway_deployment.chatbot_deployment.invoke_url}${aws_api_gateway_resource.chatbot_resource.path}"
}

# Output the Lambda role ARN (referenced from the Lambda file)
output "lambda_role_arn" {
  description = "ARN of the IAM role for Lambda"
  value       = aws_iam_role.lambda_role.arn
}