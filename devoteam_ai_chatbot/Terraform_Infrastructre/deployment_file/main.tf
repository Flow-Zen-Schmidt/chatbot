module "dynanmodb_table" {
  source = "../modules/dynamo_db_table"
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  api_name             = var.api_gateway_name
  lambda_function_name = module.lambda.function_name
  lambda_function_arn  = module.lambda.function_arn
  stage_name           = var.api_gateway_stage_name
}

module "lambda" {
  source = "../modules/lambda_chatbot"
  function_name = module.lambda_function_name
  dynamodb_table_name = module.dynamodb_table_name
  lex_bot_name = module.lex_bot_name
  lex_bot_alias_name = module.lex_bot_alias_name
  lambda_role_name = module.lambda_role_name

}