# modules/iam/main.tf

resource "aws_iam_role" "lex_role" {
  name = var.lex_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lex.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lex_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonLexFullAccess"
  role       = aws_iam_role.lex_role.name
}

output "lex_role_arn" {
  value = aws_iam_role.lex_role.arn
}
