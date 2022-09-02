# Connect  to the lambda function
resource "aws_apigatewayv2_integration" "connect-to-lambda" {
  api_id           = aws_apigatewayv2_api.http-lambda-connect.id
  integration_type = "AWS_PROXY"

  description        = "Lambda example"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.lf-tf-1.invoke_arn
}

# Manage Route GET
resource "aws_apigatewayv2_route" "lf-get-hello" {
  api_id    = aws_apigatewayv2_api.http-lambda-connect.id
  route_key ="GET /get-hello"
  target = "integrations/${aws_apigatewayv2_integration.connect-to-lambda.id}"
}

# Manage Route POST
resource "aws_apigatewayv2_route" "lf-post-hello" {
  api_id    = aws_apigatewayv2_api.http-lambda-connect.id
  route_key ="POST /post-hello"
  target = "integrations/${aws_apigatewayv2_integration.connect-to-lambda.id}"
}

# give permission to API gateway to invoke lambda

resource "aws_lambda_permission" "api-gw" {
  statement_id  = "AllowExecutionFromAPIGateway" # Sus 
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lf-tf-1.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http-lambda-connect.execution_arn}/*/*/*"
}

output "hello-base-url" {
  value = aws_apigatewayv2_stage.dev.invoke_url
}