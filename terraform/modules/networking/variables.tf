variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block assigned to the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks assigned to public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks assigned to private subnets"
  type        = list(string)
}
