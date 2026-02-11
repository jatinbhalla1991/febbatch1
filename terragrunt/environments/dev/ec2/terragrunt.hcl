# EC2 Module Configuration for Dev
include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = find_in_parent_folders("terragrunt.hcl")
}

# Point to the Terraform module
terraform {
  source = "../../../modules/ec2"
}

# Module-specific inputs (merged with environment inputs)
inputs = {
  ami_id = "ami-0c55b159cbfafe1f0"
  
  security_group_rules = {
    ssh = {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]  # Internal only for dev
    }
    http = {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

# Dependencies - run VPC module first
dependencies {
  paths = ["../vpc"]
}

dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    vpc_id     = "vpc-12345678"
    subnet_ids = ["subnet-12345678"]
  }
}
