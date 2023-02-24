## https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest

locals {
  tags = {
    Cluster       = var.cluster_name
    Environment = "production"
  }
}

module "db" {
  source = "terraform-aws-modules/rds/aws"
  version = "5.6.0"

  identifier = var.cluster_name

  engine               = "postgres"
  engine_version       = "14.3"
  family               = "postgres14"
  major_engine_version = "14"
  instance_class       = var.db_instance_class

  allocated_storage     = 100
  max_allocated_storage = 150
  storage_type          = "gp3"

  db_name  = "postgres"
  username = "postgres"
  
  # needs to be false to ensure that the password is used instead
  create_random_password = false
  password = var.db_password
  port     = 5432

  multi_az = true

  db_subnet_group_name = aws_db_subnet_group.production.name
 
  vpc_security_group_ids = [aws_security_group.rds.id]

  performance_insights_enabled = false
  create_monitoring_role       = false
  publicly_accessible          = false
  auto_minor_version_upgrade   = false

  tags = local.tags

  subnet_ids = var.subnet_ids

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = true

  create_db_option_group    = false
  create_db_parameter_group = false
}

## Supporting resources

resource "aws_db_subnet_group" "production" {
  name       = "${var.cluster_name}-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = local.tags
}

resource "aws_security_group" "rds" {
  name   = "${var.cluster_name}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}
