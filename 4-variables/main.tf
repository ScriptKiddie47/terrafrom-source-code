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
  region     = "ap-south-1"
  access_key = "access_key"
  secret_key = "secret_key"
}

variable "subnet_prefix" {
  description = "CIDR block for the subnet"
  #default
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
  vpc_id            = aws_vpc.first-vpc.id
  cidr_block        = var.subnet_prefix[0].cidr_block
  availability_zone = "ap-south-1a"
  tags = {
    Name = var.subnet_prefix[0].name
  }
}
