# 1 Create a provider tf
# 2 Create company-data-fetcher lambda function  
# 3 Create authorizer lambda function  
# 4 API Gateway configuration

variable "region" {
  description = "aws-region"
}

variable "accountId" {
    description = "AWS Account Id"
}

