variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "project" {
  description = "Prefix for resource names"
  type        = string
  default     = "notif-opt"
}

variable "mode" {
  description = "Deployment mode: legacy, optimized or both"
  type        = string
  default     = "both"

  validation {
    condition     = contains(["legacy", "optimized", "both"], var.mode)
    error_message = "mode must be one of: legacy, optimized or both."
  }
}

variable "sender_email" {
  description = "Verified SES sender email"
  type        = string
}

variable "recipient_email" {
  description = "Recipient email (must be verified in SES sandbox)"
  type        = string
}