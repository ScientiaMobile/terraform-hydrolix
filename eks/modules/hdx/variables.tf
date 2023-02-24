# Create EKS Cluster -  Module - Variables Collection (Required and Optional)

variable "cluster_name" {
  description = "Cluster name to be used"
  type        = string
}

variable "oidc_provider" {
  description = "OIDC PROVIDER to be used"
  type        = string
}
