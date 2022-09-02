# aws_apigatewayv2_api

resource "aws_apigatewayv2_api" "http-lambda-connect" {
  name          = "http-lambda-connect"
  protocol_type = "HTTP"
}

# SET STAGE
resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.http-lambda-connect.id
  name        = "dev"
  auto_deploy = true
}