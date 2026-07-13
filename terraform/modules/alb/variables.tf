variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC where the ALB and target group are created"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs used by the ALB"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group attached to the ALB"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the application container"
  type        = number
  default     = 3000
}