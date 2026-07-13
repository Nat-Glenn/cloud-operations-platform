output "db_instance_id" {
  description = "RDS database instance identifier"
  value       = aws_db_instance.main.id
}

output "db_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.main.address
}

output "db_port" {
  description = "RDS PostgreSQL port"
  value       = aws_db_instance.main.port
}

output "db_name" {
  description = "Initial PostgreSQL database name"
  value       = aws_db_instance.main.db_name
}

output "master_user_secret_arn" {
  description = "ARN of the AWS-managed database credential secret"
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}