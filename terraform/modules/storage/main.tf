resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "frontend" {
  bucket = "${var.environment}-starttech-frontend-${random_id.suffix.hex}"
  tags   = { Name = "${var.environment}-frontend-s3" }
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  index_document { suffix = "index.html" }
  error_document { key = "error.html" }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket                  = aws_s3_bucket.frontend.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.frontend.arn}/*"
    }]
  })
}

resource "aws_cloudfront_distribution" "frontend" {
  origin {
    domain_name = "${aws_s3_bucket.frontend.bucket}.s3-website-${var.aws_region}.amazonaws.com"
    origin_id   = "S3-Frontend"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  enabled             = true
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-Frontend"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }
  restrictions {
    geo_restriction { restriction_type = "none" }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  tags = { Name = "${var.environment}-cloudfront" }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.environment}-redis-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.environment}-redis"
  engine               = "redis"
  node_type            = var.redis_node_type
  num_cache_nodes      = var.redis_num_nodes
  parameter_group_name = "default.redis7"
  port                 = 6379
  security_group_ids   = [data.aws_security_group.redis.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  tags                 = { Name = "${var.environment}-redis" }
}

data "aws_security_group" "redis" {
  name   = "${var.environment}-redis-sg"
  vpc_id = data.aws_vpc.main.id
}

data "aws_vpc" "main" {
  tags = { Name = "${var.environment}-vpc" }
}

