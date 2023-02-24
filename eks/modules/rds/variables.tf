variable "db_password" {
  description = "RDS root user password"
  type        = string
}

variable "cluster_name" {
  type = string
}

variable "db_instance_class" {
  description = "DB instance class"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID of the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "VPC subnet Id's the EKS cluster"
  type        = list(string)
}