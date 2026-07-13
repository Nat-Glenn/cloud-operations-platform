variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "rds_secret_arn" {
  description = "ARN of the RDS credential secret ECS must retrieve"
  type        = string
}

