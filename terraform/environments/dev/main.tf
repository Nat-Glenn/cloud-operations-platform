module "networking" {
  source = "../../modules/networking"

  project_name = "cloud-operations-platform"
  environment  = var.environment
  vpc_cidr     = "10.0.0.0/16"



  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24",
  ]
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = "cloud-operations-platform"
  environment  = var.environment
}

module "iam" {
  source = "../../modules/iam"

  project_name   = "cloud-operations-platform"
  environment    = var.environment
  rds_secret_arn = module.rds.master_user_secret_arn
}

module "ecs" {
  source = "../../modules/ecs"

  project_name       = "cloud-operations-platform"
  environment        = var.environment
  aws_region         = var.aws_region
  log_retention_days = 7

  repository_url     = module.ecr.repository_url
  image_tag          = "v1.0.2"
  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn

  db_host        = module.rds.db_endpoint
  db_port        = module.rds.db_port
  db_name        = module.rds.db_name
  rds_secret_arn = module.rds.master_user_secret_arn

  container_port = 3000

  private_subnet_ids    = module.networking.private_subnet_ids
  ecs_security_group_id = module.networking.ecs_security_group_id
  target_group_arn      = module.alb.target_group_arn
  desired_count         = 1
}

module "rds" {
  source = "../../modules/rds"

  project_name          = "cloud-operations-platform"
  environment           = var.environment
  private_subnet_ids    = module.networking.private_subnet_ids
  rds_security_group_id = module.networking.rds_security_group_id

  database_name     = "cloud_ops"
  database_username = "cloud_ops_admin"
}

module "alb" {
  source = "../../modules/alb"

  project_name          = "cloud-operations-platform"
  environment           = var.environment
  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  alb_security_group_id = module.networking.alb_security_group_id
  container_port        = 3000
}

