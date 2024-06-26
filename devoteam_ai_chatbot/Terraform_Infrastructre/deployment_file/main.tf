module "dynanmodb_table" {
  source = "../modules/dynamo_db_table"
}

module "api_gateway" {
  source = "../modules/api_gateway"

}

module "lambda" {
  source = "../modules/lambda_chatbot"

}