# modules/lambda/main.tf

resource "aws_lambda_function" "chatbot_lambda" {
  filename      = var.lambda_filename
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime

  environment {
    variables = {
      DYNAMODB_TABLE  = var.dynamodb_table_name
      LEX_BOT_NAME    = var.lex_bot_name
      LEX_BOT_ALIAS   = var.lex_bot_alias_name
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name

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

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_lex" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonLexFullAccess"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_bedrock" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
  role       = aws_iam_role.lambda_role.name
}

output "function_name" {
  value = aws_lambda_function.chatbot_lambda.function_name
}

output "function_arn" {
  value = aws_lambda_function.chatbot_lambda.arn
}
