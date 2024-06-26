# modules/lex/variables.tf

variable "bot_name" {
  description = "Name of the Lex bot"
  type        = string
}

variable "bot_description" {
  description = "Description of the Lex bot"
  type        = string
  default     = "Lex bot for chatbot application"
}

variable "idle_session_ttl" {
  description = "Idle session TTL in seconds"
  type        = number
  default     = 300
}

variable "iam_role_arn" {
  description = "ARN of the IAM role for Lex"
  type        = string
}

variable "abort_statement" {
  description = "Abort statement for the Lex bot"
  type        = string
  default     = "Sorry, I'm having trouble understanding. Could you try rephrasing?"
}

variable "bot_alias_name" {
  description = "Name of the Lex bot alias"
  type        = string
}

variable "bot_alias_description" {
  description = "Description of the Lex bot alias"
  type        = string
  default     = "Alias for Chatbot Lex Bot"
}
