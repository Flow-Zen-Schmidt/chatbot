provider "aws" {
  region = var.aws_region
}

resource "aws_dynamodb_table" "chatbot_table" {
  name           = var.table_name
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key
  range_key      = var.range_key

  attribute {
    name = var.hash_key
    type = "S"
  }

  attribute {
    name = var.range_key
    type = "S"
  }

  attribute {
    name = "ConversationId"
    type = "S"
  }

  global_secondary_index {
    name               = "ConversationIndex"
    hash_key           = "ConversationId"
    range_key          = var.range_key
    projection_type    = "ALL"
  }

  tags = {
    Name        = var.table_name
    Environment = var.environment
  }
}