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

# my-first-ec2-server - name scoped to terrafrom
resource "aws_instance" "my-first-ec2-server" {
  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"

  tags = {
    # Name = "Ubuntu-29-08-2022"
  }
}

