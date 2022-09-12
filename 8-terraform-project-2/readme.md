REST lambda Token Authorizer

![image](https://user-images.githubusercontent.com/59485946/189231613-f16d3a28-e591-4d0b-a587-8fc3f2d23d87.png)


Steps for creating a Lambda Auth

1 . Create a Lambda Function within VPC

A role got created

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface",
                "ec2:AssignPrivateIpAddresses",
                "ec2:UnassignPrivateIpAddresses"
            ],
            "Resource": "*"
        }
    ]
}

2. REST HTTP GW Created
3. Connect to the lambda:
	You are about to give API Gateway permission to invoke your Lambda function: arn:aws:lambda:ap-south-1:378475259575:function:l_f_Hello_1

4. We see a resource based policy document attached to our Lambda Function
{
  "Version": "2012-10-17",
  "Id": "default",
  "Statement": [
    {
      "Sid": "60c19605-33e8-4c2e-a9cd-10313ab80d8b",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "lambda:InvokeFunction",
      "Resource": "arn:aws:lambda:ap-south-1:378475259575:function:l_f_Hello_1",
      "Condition": {
        "ArnLike": {
          "AWS:SourceArn": "arn:aws:execute-api:ap-south-1:378475259575:qvdbcr2j6l/*/GET/test"
        }
      }
    }
  ]
}

Before Deployment of the function we already have the rest_api_id ( search in terraform ) , this is also quite possibly the aws_api_gateway_rest_api id.

5. Create the Auth Lambda Function and attached AWSLambdaVPCAccessExecutionRole in IAM.
6. Source Code for Lambda Auth
7. Create the Authorizer : Lambda :  Token : authorizationToken
8. API Gateway needs your permission to invoke your Lambda function: arn:aws:lambda:ap-south-1:378475259575:function:l_f_Hello_1_Authorizer
9. See a policy document being attached

{
  "Version": "2012-10-17",
  "Id": "default",
  "Statement": [
    {
      "Sid": "2cc9fc7d-8645-4d28-b9d7-ead7c6aabbfc",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "lambda:InvokeFunction",
      "Resource": "arn:aws:lambda:ap-south-1:378475259575:function:l_f_Hello_1_Authorizer",
      "Condition": {
        "ArnLike": {
          "AWS:SourceArn": "arn:aws:execute-api:ap-south-1:378475259575:qvdbcr2j6l/authorizers/splq74"
        }
      }
    }
  ]
}

10. 