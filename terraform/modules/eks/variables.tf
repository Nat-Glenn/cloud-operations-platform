variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets used by the EKS cluster and worker nodes"
  type        = list(string)
}

variable "kubernetes_version" {
  description = "Kubernetes version used by Amazon EKS"
  type        = string
  default     = "1.34"
}

variable "node_instance_types" {
  description = "EC2 instance types used by the managed node group"
  type        = list(string)
  default     = ["t3.small"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}