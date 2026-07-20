data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "aws_load_balancer_controller" {
  name = "${var.cluster_name}-aws-load-balancer-controller"

  policy = file(
    "${path.module}/aws-load-balancer-controller-policy.json"
  )
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  name = "cloud-ops-dev-alb-controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "${replace(
              aws_iam_openid_connect_provider.eks.url,
              "https://",
              ""
            )}:aud" = "sts.amazonaws.com"

            "${replace(
              aws_iam_openid_connect_provider.eks.url,
              "https://",
              ""
            )}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}