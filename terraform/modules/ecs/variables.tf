variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days CloudWatch retains application logs"
  type        = number
  default     = 7
}

variable "aws_region" {
  description = "AWS region used by the task"
  type        = string
}

variable "repository_url" {
  description = "ECR repository URL containing the application image"
  type        = string
}

variable "image_tag" {
  description = "Immutable application image tag"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role used by ECS to launch the task"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role assumed by the application container"
  type        = string
}

variable "db_host" {
  description = "RDS PostgreSQL hostname"
  type        = string
}

variable "db_port" {
  description = "RDS PostgreSQL port"
  type        = number
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
}

variable "rds_secret_arn" {
  description = "ARN of the managed RDS credential secret"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the API container"
  type        = number
  default     = 3000
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the ECS service"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group attached to ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group receiving traffic from ECS"
  type        = string
}

variable "desired_count" {
  description = "Number of ECS tasks the service should maintain"
  type        = number
  default     = 1
}