# modules/lex/main.tf

resource "aws_lex_bot" "chatbot_lex" {
  name        = var.bot_name
  description = var.bot_description
  idle_session_ttl_in_seconds = var.idle_session_ttl
  role_arn    = var.iam_role_arn
  
  child_directed = false

  abort_statement {
    message {
      content      = var.abort_statement
      content_type = "PlainText"
    }
  }
}

resource "aws_lex_bot_alias" "chatbot_lex_alias" {
  bot_name    = aws_lex_bot.chatbot_lex.name
  description = var.bot_alias_description
  bot_version = "$LATEST"
  name        = var.bot_alias_name
}

output "bot_id" {
  value = aws_lex_bot.chatbot_lex.id
}

output "bot_alias_id" {
  value = aws_lex_bot_alias.chatbot_lex_alias.id
}
