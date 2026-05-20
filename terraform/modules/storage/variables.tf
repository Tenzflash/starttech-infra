variable "environment"      { type = string }
variable "aws_region"       { type = string }
variable "redis_node_type"  { type = string }
variable "redis_num_nodes"  { type = number }
variable "subnet_ids"       { type = list(string) }
