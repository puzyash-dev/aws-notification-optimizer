output "queues" {
  description = "SQS queue URLs per stack"
  value = {
    for name, m in module.sqs_lambda : name => m.queue_url
  }
}

output "functions" {
  description = "Lambda function names per stack"
  value = {
    for name, m in module.sqs_lambda : name => m.function_name
  }
}