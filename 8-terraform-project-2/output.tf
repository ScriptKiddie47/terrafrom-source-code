output "Lambda-function-name" {
  description = "Name of the Lambda function."
  value = aws_lambda_function.company_data_fetch.function_name
}

output "api-invoke-url" {
  description = "API Gateway invoke URL"
  value = aws_api_gateway_stage.stage-dev.invoke_url
}

output "stage-id" {
  description = "ID of the stage"
  value = aws_api_gateway_stage.stage-dev.id
}

output "rest_api_id" {
  description = "ID of the stage"
  value = aws_api_gateway_stage.stage-dev.rest_api_id
}

output "web_acl_arn" {
  description = "web_acl_arn"
  value = aws_api_gateway_stage.stage-dev.web_acl_arn
}