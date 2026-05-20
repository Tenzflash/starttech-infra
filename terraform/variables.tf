variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type for backend"
  type        = string
  default     = "t3.micro"
}

variable "asg_min" {
  description = "Minimum ASG size"
  type        = number
  default     = 2
}

variable "asg_max" {
  description = "Maximum ASG size"
  type        = number
  default     = 4
}

variable "asg_desired" {
  description = "Desired ASG capacity"
  type        = number
  default     = 2
}

variable "redis_node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_num_nodes" {
  description = "Number of Redis cache nodes"
  type        = number
  default     = 2
}

variable "ecr_repo_url" {
  description = "ECR repository URI for backend Docker images"
  type        = string
  default     = ""
}