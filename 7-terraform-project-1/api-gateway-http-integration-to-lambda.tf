# Connect  to the lambda function
resource "aws_apigatewayv2_integration" "connect-to-lambda-integration" {
  api_id           = aws_apigatewayv2_api.company-connect-http-api-gw.id
  integration_type = "AWS_PROXY"

  description            = "Lambda example"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.company-data-fetcher.invoke_arn
  payload_format_version = "2.0"
}

# Manage Route GET
resource "aws_apigatewayv2_route" "company-connect-get-company-files" {
  api_id             = aws_apigatewayv2_api.company-connect-http-api-gw.id
  route_key          = "GET /get-company-files"
  target             = "integrations/${aws_apigatewayv2_integration.connect-to-lambda-integration.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.example.id

  depends_on = [
    aws_apigatewayv2_authorizer.example
  ]
}


# give permission to API gateway to invoke company-data-fetcher lambda
resource "aws_lambda_permission" "company-api-gw" {
  statement_id  = "AllowExecutionFromAPIGateway" # Sus 
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.company-data-fetcher.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.company-connect-http-api-gw.execution_arn}/*/*/*"
}

# give permission to API gateway to invoke authorizer lambda
resource "aws_lambda_permission" "authorizer-api-gw" {
  statement_id  = "AllowAPIGatewayInvoke" # Sus 
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.authorizer-lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.company-connect-http-api-gw.execution_arn}/*/*/*"
}


output "hello-base-url" {
  value = aws_apigatewayv2_stage.dev.invoke_url
}
