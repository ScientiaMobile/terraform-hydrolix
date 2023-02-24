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
  default     = "production"
}

variable "node_group_instance_type" {
  description = "NodeGroup Instance type"
  type        = string

  # recommended 9xlarge in production
  default = "c5n.9xlarge"
}

variable "db_password" {
  description = "Postgres ROOT password"
  type        = string
 
  # rds password contstraints https://github.com/awsdocs/aws-cloudformation-user-guide/issues/1055 
  default = "insecurepassword"
}

variable "db_instance_class" {
  description = "DB instance class"
  type        = string

  #recommended production type
  default = "db.m5.xlarge"
}
