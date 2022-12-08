output "public_subnets" {
  value = module.vpc.private_subnets
}

output "private_subnets" {
  value = module.vpc.public_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.vpc.default_security_group_id
}

# output "default_vpc_default_security_group_id" {
#   description = "The ID of the security group created by default on Default VPC creation"
#   value       = module.vpc.default_vpc_default_security_group_id
# }

