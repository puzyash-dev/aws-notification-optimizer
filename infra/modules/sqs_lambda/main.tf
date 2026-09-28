locals {
  prefix = "${var.project}-${var.stack}"
}

# ---------- IAM ----------
resource "aws_iam_role" "lambda" {
  name = "${local.prefix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "basic_exec" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "sqs" {
  name = "${local.prefix}-sqs"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
      ]
      Resource = aws_sqs_queue.this.arn
    }]
  })
}

resource "aws_iam_role_policy" "ses" {
  name = "${local.prefix}-ses"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ses:SendEmail",
        "ses:SendRawEmail",
      ]
      Resource = "*"
    }]
  })
}

# ---------- SQS ----------
resource "aws_sqs_queue" "this" {
  name                       = "${local.prefix}-queue"
  delay_seconds              = 0
  visibility_timeout_seconds = 90
  message_retention_seconds  = 1209600
}

# ---------- Lambda ----------
resource "aws_lambda_function" "this" {
  function_name    = "${local.prefix}-fn"
  role             = aws_iam_role.lambda.arn
  handler          = "handler.lambda_handler"
  runtime          = var.runtime
  filename         = "${var.source_dir}/handler.zip"
  source_code_hash = filebase64sha256("${var.source_dir}/handler.zip")
  timeout          = 60
  memory_size      = 128

  environment {
    variables = {
      SENDER_EMAIL    = var.sender_email
      RECIPIENT_EMAIL = var.recipient_email
      STACK           = var.stack
    }
  }
}

# ---------- SQS -> Lambda trigger ----------
resource "aws_lambda_event_source_mapping" "sqs" {
  event_source_arn = aws_sqs_queue.this.arn
  function_name    = aws_lambda_function.this.arn
  batch_size       = var.sqs_batch_size
}