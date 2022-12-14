terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Hard-coded credentials are not recommended in any Terraform 
# configuration and risks secret leakage should this file ever
# be committed to a public version control system.

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = "access_key_here"
  secret_key = "secret_key_here"
}

# Create a VPC 

resource "aws_vpc" "first-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "secure-env"
  }
}

# Assign a subnet to the newly creted VPC.
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.first-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "secure-env-subnet"
  }
}
