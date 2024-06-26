# modules/api_gateway/main.tf

resource "aws_api_gateway_rest_api" "chatbot_api" {
  name        = var.api_name
  description = var.api_description
}

resource "aws_api_gateway_resource" "chatbot_resource" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  parent_id   = aws_api_gateway_rest_api.chatbot_api.root_resource_id
  path_part   = var.resource_path
}

resource "aws_api_gateway_method" "chatbot_method" {
  rest_api_id   = aws_api_gateway_rest_api.chatbot_api.id
  resource_id   = aws_api_gateway_resource.chatbot_resource.id
  http_method   = var.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.chatbot_api.id
  resource_id = aws_api_gateway_resource.chatbot_resource.id
  http_method = aws_api_gateway_method.chatbot_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.chatbot_api.execution_arn}/*/*"
}

output "invoke_url" {
  value = "${aws_api_gateway_rest_api.chatbot_api.execution_arn}/test/${var.resource_path}"
}
