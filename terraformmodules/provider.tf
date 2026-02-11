terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "my-terraform-state-1991"
    key            = "terraform/state/module.tfstate"
    region         = "us-east-1"
    encrypt        = true
    #ynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}