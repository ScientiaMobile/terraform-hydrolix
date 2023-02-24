# Create EKS Cluster - Final Output
#

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "external_rds_postgres_endpoint" {
  description = "AWS RDS endpoint"
  value       = module.external_rds_postgres.external_rds_postgres_endpoint
}
