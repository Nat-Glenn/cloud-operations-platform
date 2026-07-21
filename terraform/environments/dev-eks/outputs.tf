output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "API endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_node_group_name" {
  description = "Name of the managed EKS node group"
  value       = module.eks.node_group_name
}

output "ecr_repository_url" {
  description = "ECR repository URL for the EKS application"
  value       = module.ecr.repository_url
}

output "rds_endpoint" {
  description = "EKS environment PostgreSQL endpoint"
  value       = module.rds.db_endpoint
}

output "rds_port" {
  description = "PostgreSQL port"
  value       = module.rds.db_port
}

output "rds_master_secret_arn" {
  description = "ARN of the managed RDS credential secret"
  value       = module.rds.master_user_secret_arn
}

output "aws_load_balancer_controller_role_arn" {
  value = module.eks.aws_load_balancer_controller_role_arn
}

output "application_ci_role_arn" {
  description = "IAM role assumed by the application GitHub Actions workflow"
  value       = aws_iam_role.application_ci.arn
}

output "terraform_ci_role_arn" {
  value = aws_iam_role.terraform_ci.arn
}