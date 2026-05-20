#!/bin/bash
set -e

# Update & Install Docker
yum update -y
amazon-linux-extras install docker -y
systemctl enable docker --now

# Pull & Run Backend Container
ECR_REPO="${ECR_REPO_URL}"
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
docker pull ${ECR_REPO}:latest
docker run -d -p 8080:8080 --name backend --restart always \
  -e REDIS_URL=${REDIS_URL} \
  -e DB_URI=${DB_URI} \
  ${ECR_REPO}:latest

# Install CloudWatch Agent
wget -q https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOF'
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/backend-app.log",
            "log_group_name": "/starttech/prod/backend",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
EOF
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
