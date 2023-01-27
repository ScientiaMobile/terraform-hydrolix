# Create EKS cluster and dependencies 

locals {
  # change to meet your naming standards - this format handles multi region
  cluster_name = "hdx-${var.cluster_name}-${var.aws_region}"
}

module "eks" {
  source = "../../modules/eks"

  cluster_name             = local.cluster_name
  node_group_instance_type = var.node_group_instance_type

  # explicit dependency on vpc module
  vpc_id                = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnets
  private_subnets       = module.vpc.private_subnets
  vpc_security_group_id = module.vpc.default_security_group_id
}

module "vpc" {
  source       = "../../modules/vpc"
  cluster_name = local.cluster_name
}

module "s3" {
  source       = "../../modules/s3"
  cluster_name = local.cluster_name
}

module "autoscaler" {
  source = "../../modules/autoscaler"

  # explicit dependencies on eks module
  cluster_name  = module.eks.cluster_name
  oidc_provider = module.eks.oidc_provider

  region = var.aws_region
}

module "hdx" {
  source       = "../../modules/hdx"
  cluster_name = local.cluster_name

  # explicit dependency on eks module
  oidc_provider = module.eks.oidc_provider
}

# resource "null_resource" "kubectl" {
#     provisioner "local-exec" {
#         command = "aws eks update-kubeconfig --region ${var.aws_region}  --name ${module.eks.cluster_name}"
#     }
# }