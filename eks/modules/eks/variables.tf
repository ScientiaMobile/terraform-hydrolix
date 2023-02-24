# Create EKS Cluster - EKS Module - Variables Collection (Required and Optional)

variable "cluster_name" {
  type = string
}

variable "node_group_instance_type" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = set(string)
}

variable "private_subnets" {
  type = set(string)
}

variable "vpc_security_group_id" {
  type = string
}
