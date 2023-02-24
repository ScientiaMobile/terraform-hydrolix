data "aws_caller_identity" "current" {}

# https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md
# https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md#IAM-Policy


resource "helm_release" "autoscaler" {

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"

  # this name gets prefixed to the service account name aws-cluster-autoscaler
  # TODO: check for a better solution than using ca-aws-cluster-autoscaler in IAM
  name = "ca"

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "cloudProvder"
    value = "aws"
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.autoscaler.name}"
  }

  depends_on = [
    aws_iam_role_policy_attachment.autoscaler
  ]
}

# https://github.com/kubernetes-sigs/metrics-server/tree/master/charts/metrics-server
resource "helm_release" "metrics-server" {

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  name       = "metrics-server"
}
