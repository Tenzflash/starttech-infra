terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source      = "./modules/networking"
  vpc_cidr    = var.vpc_cidr
  environment = var.environment
}

module "compute" {
  source           = "./modules/compute"
  vpc_id           = module.networking.vpc_id
  subnet_ids       = module.networking.private_subnet_ids
  alb_sg_id        = module.networking.alb_sg_id
  ec2_sg_id        = module.networking.ec2_sg_id
  environment      = var.environment
  ecr_repo_url     = var.ecr_repo_url
  instance_type    = var.instance_type
  min_size         = var.asg_min
  max_size         = var.asg_max
  desired_capacity = var.asg_desired
}

module "storage" {
  
  subnet_ids      = module.networking.private_subnet_ids
  source          = "./modules/storage"
  environment     = var.environment
  aws_region      = var.aws_region
  redis_node_type = var.redis_node_type
  redis_num_nodes = var.redis_num_nodes
}

module "monitoring" {
  source          = "./modules/monitoring"
  environment     = var.environment
  log_group_names = [module.compute.backend_log_group_name]
}

