data "aws_iam_policy_document" "apig_lambda_policy" {
  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    effect    = "Allow"
    resources = [aws_lambda_function.authorizer-lambda.arn]
    sid       = "ApiGatewayInvokeLambda"
  }
}


data "aws_iam_policy_document" "apig_lambda_role_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "apig_lambda_role" {
  name               = "apigateway-authorize-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.apig_lambda_role_assume.json
}

resource "aws_iam_policy" "apig_lambda" {
  name   = "apig-lambda-policy"
  policy = data.aws_iam_policy_document.apig_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "apig_lambda_role_to_policy" {
  role       = aws_iam_role.apig_lambda_role.name
  policy_arn = aws_iam_policy.apig_lambda.arn
}

resource "aws_apigatewayv2_authorizer" "example" {
  authorizer_payload_format_version = "2.0"
  api_id                            = aws_apigatewayv2_api.company-connect-http-api-gw.id
  authorizer_type                   = "REQUEST"
  authorizer_result_ttl_in_seconds  = "0"
  identity_sources                  = ["$request.header.Authorization"]
  name                              = "company-authorizer"
  authorizer_uri                    = aws_lambda_function.authorizer-lambda.invoke_arn
  enable_simple_responses           = true
  authorizer_credentials_arn        = aws_iam_role.apig_lambda_role.arn
}