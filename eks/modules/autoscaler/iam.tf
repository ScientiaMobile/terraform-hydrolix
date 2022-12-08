
resource "aws_iam_policy" "autoscaler" {
  name = "${var.cluster_name}-autoscaler"
  policy      = jsonencode({   
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeImages",
                "ec2:GetInstanceTypesFromInstanceRequirements",
                "eks:DescribeNodegroup"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeAutoScalingGroups",
                "ec2:DescribeLaunchTemplateVersions",
                "autoscaling:DescribeTags",
                "autoscaling:DescribeLaunchConfigurations",
                "ec2:DescribeInstanceTypes"
            ],
            "Resource": "*"
        }
    ]
  })
}

resource "aws_iam_role" "autoscaler" {
   name = "${var.cluster_name}-autoscaler-role"
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
            "${var.oidc_provider}:sub": "system:serviceaccount:kube-system:ca-aws-cluster-autoscaler"
          }
        }
      }
    ]
  })
 }

resource "aws_iam_role_policy_attachment" "autoscaler" {
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${aws_iam_policy.autoscaler.name}"
  role       = aws_iam_role.autoscaler.name
}
