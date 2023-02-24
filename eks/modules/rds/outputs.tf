output "external_rds_postgres_endpoint" {
  description = "The connection endpoint"
  value       = module.db.db_instance_endpoint
}
