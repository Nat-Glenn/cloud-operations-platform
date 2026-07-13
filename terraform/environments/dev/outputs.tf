output "public_subnet_ids" {
  description = "IDs of development public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of development private subnets"
  value       = module.networking.private_subnet_ids
}

output "availability_zones" {
  description = "Availability Zones used by development subnets"
  value       = module.networking.availability_zones
}

output "internet_gateway_id" {
  description = "ID of the development Internet Gateway"
  value       = module.networking.internet_gateway_id
}

output "public_route_table_id" {
  description = "ID of the development public route table"
  value       = module.networking.public_route_table_id
}

output "private_route_table_id" {
  description = "ID of the development private route table"
  value       = module.networking.private_route_table_id
}

output "nat_gateway_id" {
  description = "ID of the development NAT Gateway"
  value       = module.networking.nat_gateway_id
}

output "nat_elastic_ip" {
  description = "Public IP of the development NAT Gateway"
  value       = module.networking.nat_elastic_ip
}

output "alb_security_group_id" {
  value = module.networking.alb_security_group_id
}

output "ecs_security_group_id" {
  value = module.networking.ecs_security_group_id
}

output "rds_security_group_id" {
  value = module.networking.rds_security_group_id
}

output "ecr_repository_name" {
  description = "Name of the development ECR repository"
  value       = module.ecr.repository_name
}

output "ecr_repository_url" {
  description = "URL of the development ECR repository"
  value       = module.ecr.repository_url
}

output "ecs_execution_role_arn" {
  description = "ARN of the development ECS execution role"
  value       = module.iam.ecs_execution_role_arn
}

output "ecs_task_role_arn" {
  description = "ARN of the development ECS task role"
  value       = module.iam.ecs_task_role_arn
}

output "ecs_cluster_name" {
  description = "Name of the development ECS cluster"
  value       = module.ecs.cluster_name
}

output "cloudwatch_log_group_name" {
  description = "Name of the development application log group"
  value       = module.ecs.log_group_name
}

output "rds_endpoint" {
  description = "Development PostgreSQL endpoint"
  value       = module.rds.db_endpoint
}

output "rds_port" {
  description = "Development PostgreSQL port"
  value       = module.rds.db_port
}

output "rds_master_secret_arn" {
  description = "ARN of the managed RDS credential secret"
  value       = module.rds.master_user_secret_arn
}

output "alb_dns_name" {
  description = "Public DNS name of the development ALB"
  value       = module.alb.alb_dns_name
}

output "alb_target_group_arn" {
  description = "ARN of the development target group"
  value       = module.alb.target_group_arn
}

output "ecs_service_name" {
  description = "Name of the development ECS service"
  value       = module.ecs.service_name
}