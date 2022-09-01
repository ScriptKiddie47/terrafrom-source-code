# 1. AWS IAM ROLE
resource "aws_iam_role" "lambda-role-tf1" {
  name = "lambda-role-tf1"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    basic-info       = "lambda-role-tf1-tag"
    production-ready = "no"
  }
}

#2 IAM POLICY for the role ( USER DEFINED POLICY SO WE CAN NAME IT AS WE WANT )

resource "aws_iam_policy" "lambda-policy-tf1" {
  name        = "lambda-role-tf1-policy"
  path        = "/"
  description = "policy role for aws lambda"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
    ]
  })
}

# 3 POLICY ATTACHMENT ON THE ROLE

resource "aws_iam_policy_attachment" "lambda-policy-tf1-attach-lambda-role-tf1" {
  name       = "lambda-policy-tf1-attach-lambda-role-tf1"
  roles      = [aws_iam_role.lambda-role-tf1.name]
  policy_arn = aws_iam_policy.lambda-policy-tf1.arn #notice the ARN
}

# 4 DATA BLOCK or archive_file
# https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/archive_file
# the block is responsible for creating the zip file 

# Archive a single file.
data "archive_file" "zip_js_code" {
  type        = "zip"
  source_file = "./node-js/hello-world.js"
  output_path = "./node-js/hello-world.zip"
}


# 5 AWS LAMBDA function
resource  "aws_lambda_function" "lf-tf-1" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.

  filename      = "./node-js/hello-world.zip"
  function_name = "lf-tf-hello-world-node-1"
  role          = aws_iam_role.lambda-role-tf1.arn
  handler       = "hello-world.handler"
  runtime       = "nodejs16.x"

  depends_on = [
    aws_iam_policy_attachment.lambda-policy-tf1-attach-lambda-role-tf1
  ]
}
