variable "aws_region" {
  description = "AWS region where resources are created"
  type        = string
  default     = "ca-central-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev-eks"
}