module "networking" {
  source = "../../modules/networking"

  project_name = "cloud-operations-platform"
  environment  = var.environment
  vpc_cidr     = "10.10.0.0/16"

  public_subnet_cidrs = [
    "10.10.1.0/24",
    "10.10.2.0/24",
  ]

  private_subnet_cidrs = [
    "10.10.11.0/24",
    "10.10.12.0/24",
  ]
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = "cloud-operations-platform"
  environment  = var.environment
}


module "eks" {
  source = "../../modules/eks"

  project_name       = "cloud-operations-platform"
  environment        = var.environment
  private_subnet_ids = module.networking.private_subnet_ids
  cluster_name       = "cloud-operations-platform-dev-eks-cluster"

  kubernetes_version = "1.34"

  node_instance_types = ["t3.small"]
  node_desired_size   = 2
  node_min_size       = 2
  node_max_size       = 3
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