# 2.1. Create IAM Role
resource "aws_iam_role" "company-data-fetcher-iam-role" {
  name = "company-data-fetcher-iam-role"

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
    basic-info       = "company-data-fetcher"
    production-ready = "no"
  }
}


# 2.2 POLICY ATTACHMENT ON THE ROLE

resource "aws_iam_role_policy_attachment" "company-data-fetcher_policy" {
  role       = aws_iam_role.company-data-fetcher-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# 4 DATA BLOCK or archive_file
# https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/archive_file
# the block is responsible for creating the zip file 

# 2.3 Archive a single file.
data "archive_file" "zip_js_code" {
  type        = "zip"
  source_file = "./node-source/company-data-fetcher.js"
  output_path = "./node-source/company-data-fetcher.zip"
}

# 2.4 AWS LAMBDA function
resource "aws_lambda_function" "company-data-fetcher" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.

  filename      = "./node-source/company-data-fetcher.zip"
  function_name = "company-data-fetcher"
  role          = aws_iam_role.company-data-fetcher-iam-role.arn
  handler       = "company-data-fetcher.handler"
  runtime       = "nodejs16.x"

  # Use modules 
  vpc_config {
    subnet_ids         = ["subnet-084249d0577563aa0", "subnet-05616c846be1d455b", "subnet-03e91cae7b847b8c8"]
    security_group_ids = ["sg-05f7224fcc9a3e20c"]
  }


  depends_on = [
    aws_iam_role_policy_attachment.company-data-fetcher_policy
  ]
}
