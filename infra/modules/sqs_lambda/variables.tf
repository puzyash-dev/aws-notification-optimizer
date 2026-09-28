variable "project" {
  type = string
}

variable "stack" {
  type = string
}

variable "source_dir" {
  type = string
}

variable "sender_email" {
  type = string
}

variable "recipient_email" {
  type = string
}

variable "runtime" {
  type    = string
  default = "python3.13"
}

variable "sqs_batch_size" {
  type    = number
  default = 1
}