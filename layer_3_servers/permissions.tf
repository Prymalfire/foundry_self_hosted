resource "aws_iam_role" "foundry_server_role" {
  name = "foundry-server-role-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "Foundry Server Role"
  }
}

locals {
  bucket_arns = [
    for region, bucket in data.terraform_remote_state.storage.outputs.foundry_data_buckets :
    {
      region : bucket.arn
    }
  ]
}

resource "aws_iam_policy" "s3_policy" {
  name        = "foundry-server-s3-access-policy-"
  description = "Policy to allow Foundry servers to access S3 buckets"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
          Resource = flatten([
            for region in local.regions : [
              "${data.terraform_remote_state.storage.outputs.foundry_data_buckets[region].arn}",
              "${data.terraform_remote_state.storage.outputs.foundry_data_buckets[region].arn}/*"
            ]
          ])
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.foundry_server_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

# -- Instance Profile --

resource "aws_iam_instance_profile" "foundry_server_instance_profile" {
  name = "foundry-server-instance-profile-"
  role = aws_iam_role.foundry_server_role.name
}

