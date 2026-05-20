output "alb_dns_name"       { value = aws_lb.app.dns_name }
output "backend_log_group_name" { value = aws_cloudwatch_log_group.backend.name }
