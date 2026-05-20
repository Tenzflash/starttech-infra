output "frontend_s3_bucket" { value = aws_s3_bucket.frontend.id }
output "cloudfront_domain"  { value = aws_cloudfront_distribution.frontend.domain_name }
output "redis_endpoint"     { value = aws_elasticache_cluster.redis.cache_nodes[0].address }
