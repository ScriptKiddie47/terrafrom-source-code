output "amazon-domain-name" {
  description = "Amazon Domain Name"
  value       = aws_cognito_user_pool_domain.main.domain
}

output "cloudfront_distribution_arn" {
  description = "cloudfront_distribution_arn"
  value       = aws_cognito_user_pool_domain.main.cloudfront_distribution_arn
}
