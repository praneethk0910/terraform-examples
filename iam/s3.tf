provider "aws" {
  region = "us-west-2"
}

# IAM Policies
resource "aws_iam_policy" "dev_policy" {
  name        = "DeveloperPolicy"
  description = "Permissions for Developer group"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:ListBucket", "s3:GetObject"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["ec2:DescribeInstances", "ec2:StartInstances", "ec2:StopInstances"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "devops_policy" {
  name        = "DevOpsPolicy"
  description = "Permissions for DevOps group"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["ec2:*"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["cloudformation:*"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "admin_policy" {
  name        = "AdminPolicy"
  description = "Permissions for Admin group"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "readonly_policy" {
  name        = "ReadonlyPolicy"
  description = "Permissions for ReadOnly group"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:ListBucket", "s3:GetObject", "ec2:DescribeInstances"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# IAM Groups
resource "aws_iam_group" "developer_group" {
  name = "DeveloperGroup"
}

resource "aws_iam_group" "devops_group" {
  name = "DevOpsGroup"
}

resource "aws_iam_group" "admin_group" {
  name = "AdminGroup"
}

resource "aws_iam_group" "readonly_group" {
  name = "ReadonlyGroup"
}

# Attach Policies to Groups
resource "aws_iam_group_policy_attachment" "dev_policy_attach" {
  group      = aws_iam_group.developer_group.name
  policy_arn = aws_iam_policy.dev_policy.arn
}

resource "aws_iam_group_policy_attachment" "devops_policy_attach" {
  group      = aws_iam_group.devops_group.name
  policy_arn = aws_iam_policy.devops_policy.arn
}

resource "aws_iam_group_policy_attachment" "admin_policy_attach" {
  group      = aws_iam_group.admin_group.name
  policy_arn = aws_iam_policy.admin_policy.arn
}

resource "aws_iam_group_policy_attachment" "readonly_policy_attach" {
  group      = aws_iam_group.readonly_group.name
  policy_arn = aws_iam_policy.readonly_policy.arn
}

# IAM Users
resource "aws_iam_user" "dev_user" {
  name = "dev_user"
}

resource "aws_iam_user" "devops_user" {
  name = "devops_user"
}

resource "aws_iam_user" "admin_user" {
  name = "admin_user"
}

resource "aws_iam_user" "readonly_user" {
  name = "readonly_user"
}

# Attach Users to Groups
resource "aws_iam_user_group_membership" "dev_user_group" {
  user = aws_iam_user.dev_user.name
  groups = [aws_iam_group.developer_group.name]
}

resource "aws_iam_user_group_membership" "devops_user_group" {
  user = aws_iam_user.devops_user.name
  groups = [aws_iam_group.devops_group.name]
}

resource "aws_iam_user_group_membership" "admin_user_group" {
  user = aws_iam_user.admin_user.name
  groups = [aws_iam_group.admin_group.name]
}

resource "aws_iam_user_group_membership" "readonly_user_group" {
  user = aws_iam_user.readonly_user.name
  groups = [aws_iam_group.readonly_group.name]
}
