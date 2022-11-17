# 1 Create API GW
resource "aws_api_gateway_rest_api" "fc_gw_rest" {
  name = "company-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
  depends_on = [
    aws_lambda_function.company_data_fetch
  ]
}

# 2 Define a Resouces

resource "aws_api_gateway_resource" "fetch_data" {
  rest_api_id = aws_api_gateway_rest_api.fc_gw_rest.id
  parent_id   = aws_api_gateway_rest_api.fc_gw_rest.root_resource_id
  path_part   = "fetch"

  depends_on = [
    aws_api_gateway_rest_api.fc_gw_rest
  ]
}

# 3 : Create a GET Method

resource "aws_api_gateway_method" "get_method" {
  rest_api_id          = aws_api_gateway_rest_api.fc_gw_rest.id
  resource_id          = aws_api_gateway_resource.fetch_data.id
  http_method          = "GET"
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.oauth2_cog.id
  authorization_scopes = aws_cognito_resource_server.resource_server.scope_identifiers

  depends_on = [
    aws_api_gateway_resource.fetch_data
  ]

}

# 4 : Lambda Integration with Resource

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.fc_gw_rest.id
  resource_id             = aws_api_gateway_resource.fetch_data.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.company_data_fetch.invoke_arn

  depends_on = [
    aws_api_gateway_method.get_method
  ]
}

# 5 Lambda Permission for company_data_fetch

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.company_data_fetch.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region.aws_region}:${var.accountId.acc_id}:${aws_api_gateway_rest_api.fc_gw_rest.id}/*/${aws_api_gateway_method.get_method.http_method}${aws_api_gateway_resource.fetch_data.path}"

  depends_on = [
    aws_api_gateway_integration.integration
  ]
}

# 6 Deployment

resource "aws_api_gateway_deployment" "fc_gw_rest_deploy" {
  rest_api_id = aws_api_gateway_rest_api.fc_gw_rest.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.fetch_data.id,
      aws_api_gateway_method.get_method.id,
      aws_api_gateway_integration.integration.id,
    ]))

  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_lambda_permission.apigw_lambda
  ]
}

# 7 Stagging

resource "aws_api_gateway_stage" "stage-dev" {
  deployment_id = aws_api_gateway_deployment.fc_gw_rest_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.fc_gw_rest.id
  stage_name    = "dev-1"

  depends_on = [
    aws_api_gateway_deployment.fc_gw_rest_deploy
  ]
}

# 8 Cognito Authorizer ( OAuth 2.0 )

resource "aws_api_gateway_authorizer" "oauth2_cog" {
  name          = "Oauth2.0"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.fc_gw_rest.id
  provider_arns = ["${aws_cognito_user_pool.company_user_pool.arn}"]
}
