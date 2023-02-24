
variable "cluster_name" {
  description = "Cluster name to be used"
  type        = string
}

variable "oidc_provider" {
  description = "OIDC PROVIDER to be used"
  type        = string
}

variable "region" {
  description = "AWS region to be used"
  type        = string
}
