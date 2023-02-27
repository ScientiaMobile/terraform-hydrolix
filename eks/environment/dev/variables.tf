# Create EKS Cluster - Variables Collection
#
variable "profile" {
  description = "AWS credential Profile (normally found in ~/.aws/config)"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "development"
}

variable "node_group_instance_type" {
  description = "NodeGroup Instance type"
  type        = string
  # for larger trials 4xlarge or 9xlarge in production
  default = "c5n.2xlarge"
}
