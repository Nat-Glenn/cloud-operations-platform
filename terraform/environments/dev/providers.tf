provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "cloud-operations-platform"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}