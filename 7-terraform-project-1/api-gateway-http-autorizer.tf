resource "aws_apigatewayv2_authorizer" "example" {
  authorizer_payload_format_version = "2.0"
  api_id                            = aws_apigatewayv2_api.company-connect-http-api-gw.id
  authorizer_type                   = "REQUEST"
  authorizer_result_ttl_in_seconds  = "0"
  identity_sources                  = ["$request.header.Authorization"]
  name                              = "company-authorizer"
  authorizer_uri                    = aws_lambda_function.authorizer-lambda.invoke_arn
  enable_simple_responses           = true
  authorizer_credentials_arn        = aws_iam_role.authorizer-lambda-iam-role.arn 
}