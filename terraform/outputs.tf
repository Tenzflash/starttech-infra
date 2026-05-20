output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "cloudfront_domain" {
  description = "CloudFront distribution domain for frontend"
  value       = module.storage.cloudfront_domain
}

output "s3_frontend_bucket" {
  description = "S3 bucket name hosting the React frontend"
  value       = module.storage.frontend_s3_bucket
}

output "redis_endpoint" {
  description = "ElastiCache Redis cluster endpoint"
  value       = module.storage.redis_endpoint
}

output "backend_log_group" {
  description = "CloudWatch Log Group for backend application"
  value       = module.monitoring.backend_log_group
}