# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name                 =  var.cluster_name
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true # enable_nat_gateway, bool, should be true to provision NAT Gateways for each the private networks
  single_nat_gateway   = true # single_nat_gateway, bool, should be true to provision a single shared NAT Gateway across all private networks
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
  }

  vpc_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
