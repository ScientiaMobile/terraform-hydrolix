data "aws_caller_identity" "current" {}

 resource "aws_iam_role" "bucket_access_role" {
   name = "${var.cluster_name}-bucket"
   assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${var.oidc_provider}:aud": "sts.amazonaws.com",
            "${var.oidc_provider}:sub": "system:serviceaccount:${var.cluster_name}:hydrolix"
          }
        }
      },
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${var.oidc_provider}:aud": "sts.amazonaws.com",
            "${var.oidc_provider}:sub": "system:serviceaccount:${var.cluster_name}:turbine-api"
          }
        }
      },
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${var.oidc_provider}:aud": "sts.amazonaws.com",
            "${var.oidc_provider}:sub": "system:serviceaccount:${var.cluster_name}:merge-controller"
          }
        }
      },
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${var.oidc_provider}:aud": "sts.amazonaws.com",
            "${var.oidc_provider}:sub": "system:serviceaccount:${var.cluster_name}:vector"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bucket_access_role_attachment" {
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${aws_iam_role.bucket_access_role.name}"
  role       = aws_iam_role.bucket_access_role.name
}
