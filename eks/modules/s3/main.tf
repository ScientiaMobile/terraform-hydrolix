# https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "hdx" {
  bucket = var.cluster_name

  tags = {
    Cluster = var.cluster_name
  }
}

resource "aws_s3_bucket_public_access_block" "hdx" {
  bucket = aws_s3_bucket.hdx.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_policy" "hdx" {
  name = "${var.cluster_name}-bucket"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid":"ListObjectsInBucket",
        "Effect": "Allow",
        "Action": "s3:ListBucket",
        "Resource": [
          "${aws_s3_bucket.hdx.arn}",
          "arn:aws:s3:::hdx-public"
        ]  
      },
      {
        "Sid":"AllObjectActions",
        "Effect": "Allow",
        "Action": "s3:*Object",
        "Resource": [
          "${aws_s3_bucket.hdx.arn}/*",
          "arn:aws:s3:::hdx-public/*"
        ]  
      }      
    ]
  })
}