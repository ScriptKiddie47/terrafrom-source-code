resource "aws_api_gateway_authorizer" "l-auth" {
  name                             = "l-auth"
  rest_api_id                      = aws_api_gateway_rest_api.fc_gw_rest.id
  authorizer_uri                   = aws_lambda_function.authorizer-lambda.invoke_arn
  authorizer_credentials           = aws_iam_role.invocation_role.arn
  type                             = "TOKEN"
  authorizer_result_ttl_in_seconds = 0

  depends_on = [
    aws_api_gateway_resource.fetch_data
  ]
}

resource "aws_iam_role" "invocation_role" {
  name = "api_gateway_rest_auth_invocation"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invocation_policy" {
  name = "default"
  role = aws_iam_role.invocation_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${aws_lambda_function.authorizer-lambda.arn}"
    }
  ]
}
EOF
}
