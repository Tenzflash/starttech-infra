output "dashboard_name" {
  value = aws_cloudwatch_dashboard.starttech.dashboard_name
}
output "backend_log_group" {
  value = var.log_group_names[0]
}
