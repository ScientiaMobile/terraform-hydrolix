#
# Remote state and lock files
# Usage: copy this file terraform_remote.tf into any directory that we will use to manage infrastruture or services

# Changing the key to something unique (been using the directory path) allows changes to be made to different parts of the infrastructure at the same time. 
#  
# If we decide we want to lock the entire infrastucture while making changes we ensure that all keys are the same. 
#  

resource "aws_s3_bucket" "terraform-remote-state" {
  count  = 1 # disable
  bucket = "com.scientiamobile.hydrolix.terraform-remote-state-dev"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [grant]
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name    = "Hydrolix Terraform State"
    Product = "Hydrolix"
  }
}

// Create dynamodb
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}


// Comment out the below when initializing a new account. 
// After the first terraform apply (creating the above bucket), enable the new backend
// and run terraform init
/*
terraform {
  backend "s3" {
    encrypt = true

    # production bucket should be sans .accountnumber
    bucket         = "com.scientiamobile.hydrolix.terraform-remote-state-dev" 
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "us-east-2"
    profile        = "aws-hydrolix-dev"
    key            = "terraform/hydrolix/dev" 
  }
}
*/
