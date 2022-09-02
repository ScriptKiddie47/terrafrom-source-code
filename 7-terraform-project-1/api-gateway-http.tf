resource "aws_apigatewayv2_api" "company-connect-http-api-gw" {
  name          = "company-connect-http-api-gw"
  protocol_type = "HTTP"
}

# SET STAGE
resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.company-connect-http-api-gw.id
  name        = "dev"
  auto_deploy = true
}