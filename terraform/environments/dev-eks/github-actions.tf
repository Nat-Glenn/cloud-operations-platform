data "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "application_ci" {
  name = "cloud-ops-dev-application-ci"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github_actions.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:Nat-Glenn/cloud-operations-platform:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "application_ci_ecr" {
  name = "cloud-ops-dev-application-ci-ecr"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ECRAuthentication"
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },
      {
        Sid    = "PushApplicationImages"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]

        Resource = [
          "arn:aws:ecr:ca-central-1:386566550877:repository/cloud-operations-scanning-service",
          "arn:aws:ecr:ca-central-1:386566550877:repository/cloud-operations-licensing-service",
          "arn:aws:ecr:ca-central-1:386566550877:repository/cloud-operations-notification-service"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "application_ci_ecr" {
  role       = aws_iam_role.application_ci.name
  policy_arn = aws_iam_policy.application_ci_ecr.arn
}

resource "aws_iam_role" "terraform_ci" {
  name = "cloud-ops-dev-terraform-ci"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github_actions.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:Nat-Glenn/cloud-operations-platform:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_ci_read_only" {
  role       = aws_iam_role.terraform_ci.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_policy" "terraform_ci_state" {
  name = "cloud-ops-dev-terraform-ci-state"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::cloud-operations-platform-386566550877-tfstate"
      },
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "arn:aws:s3:::cloud-operations-platform-386566550877-tfstate/dev-eks/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_ci_state" {
  role       = aws_iam_role.terraform_ci.name
  policy_arn = aws_iam_policy.terraform_ci_state.arn
}