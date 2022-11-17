terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
  shared_credentials_files = ["C:/Users/Syn/.aws/credentials"]
}