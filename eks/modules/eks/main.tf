# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

data "aws_caller_identity" "current" {}

locals {
  cluster_version = "1.24"
  volume_size = 128
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = var.cluster_name
  cluster_version = local.cluster_version

  vpc_id                   = var.vpc_id
  control_plane_subnet_ids = var.private_subnets
  subnet_ids               = var.public_subnets
  
  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = aws_iam_role.aws-ebs-csi-driver-role.arn
    }
    vpc-cni = {}  
  }

  create_iam_role          = true
  iam_role_name            = "${var.cluster_name}-cluster-service-role"
  iam_role_use_name_prefix = false

  # enable_irsa = true
  
  eks_managed_node_group_defaults = {
    # See https://github.com/aws/containers-roadmap/issues/1666 for more context
    iam_role_attach_cni_policy = true
  }

  # https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1885#issuecomment-1044614330
  # required by metric-server
  node_security_group_additional_rules = {
    metrics_server_ingress = {
      description                   = "Cluster API to metrics server 4443 ingress port"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 4443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  eks_managed_node_groups = {
    eks-mngd = {

      subnet_ids = var.private_subnets
      vpc_security_group_ids = [var.vpc_security_group_id]

      instance_types       = [var.node_group_instance_type]      
      min_size     = 0
      max_size     = 30
      desired_size = 3
      ebs_optimized  = false
      dedicated                            = true
      exclude_from_external_load_balancers = true
      iam_role_use_name_prefix             = false

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = local.volume_size
            volume_type           = "gp3"
            iops                  = 3000
            delete_on_termination = true
          }
        }
      }

      tags = {
       "k8s.io/cluster-autoscaler/enabled" = true,
       "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"        
      }
    }
  }
  
   aws_auth_users = [
    {
      userarn  = data.aws_caller_identity.current.arn
      username = data.aws_caller_identity.current.user_id
      groups   = ["system:masters"]
    }
  ]
}