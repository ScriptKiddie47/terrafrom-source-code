#1 Create a simple user pool
resource "aws_cognito_user_pool" "company_user_pool" {
  name              = "company-user-pool"
  mfa_configuration = "OFF"
}

#2 Create a Domain
resource "aws_cognito_user_pool_domain" "main" {
  domain       = "company-user-pool-tbh-temp"
  user_pool_id = aws_cognito_user_pool.company_user_pool.id

  depends_on = [
    aws_cognito_user_pool.company_user_pool
  ]
}

#3 Create a resource server
resource "aws_cognito_resource_server" "resource_server" {
  identifier = "company-user-pool-rs"
  name       = "company-user-pool-rs"
  scope {
    scope_name        = "read"
    scope_description = "read"
  }
  user_pool_id = aws_cognito_user_pool.company_user_pool.id
}


#4 Create an app client ( Create a basic user pool client )

resource "aws_cognito_user_pool_client" "userpool_client" {
  name                                 = "client"
  generate_secret                      = true
  user_pool_id                         = aws_cognito_user_pool.company_user_pool.id
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_scopes                 = aws_cognito_resource_server.resource_server.scope_identifiers
  supported_identity_providers         = ["COGNITO"]

  depends_on = [
    aws_cognito_resource_server.resource_server
  ]
}

 