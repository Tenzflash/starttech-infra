resource "aws_cloudwatch_metric_alarm" "backend_high_cpu" {
  alarm_name          = "${var.environment}-backend-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggers when backend CPU exceeds 80% for 10 minutes"
  dimensions = {
    AutoScalingGroupName = "${var.environment}-backend-asg"
  }
  tags = { Environment = var.environment }
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "${var.environment}-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "Triggers when ALB 5XX errors exceed 10 per minute"
  dimensions = {
    LoadBalancer = "${var.environment}-alb"
  }
  tags = { Environment = var.environment }
}

data "aws_region" "current" {}

resource "aws_cloudwatch_dashboard" "starttech" {
  dashboard_name = "${var.environment}-starttech-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          view    = "timeSeries"
          metrics = [["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${var.environment}-backend-asg"]]
          region  = data.aws_region.current.name
          title   = "Backend CPU Utilization"
        }
      },
      {
        type   = "log"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          view   = "table"
          logs   = ["/starttech/${var.environment}/backend"]
          region = data.aws_region.current.name
          title  = "Application Logs"
        }
      }
    ]
  })
}
