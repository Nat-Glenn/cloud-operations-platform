variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the RDS subnet group"
  type        = list(string)
}

variable "rds_security_group_id" {
  description = "Security group attached to the RDS instance"
  type        = string
}

variable "database_name" {
  description = "Initial PostgreSQL database name"
  type        = string
  default     = "cloud_ops"
}

variable "database_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "cloud_ops_admin"
}