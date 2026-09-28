locals {
  modes = var.mode == "both" ? ["legacy", "optimized"] : [var.mode]
}

module "sqs_lambda" {
  source   = "./modules/sqs_lambda"
  for_each = toset(local.modes)

  project         = var.project
  stack           = each.key
  source_dir      = "${path.module}/../lambda/${each.key}"
  sender_email    = var.sender_email
  recipient_email = var.recipient_email
}