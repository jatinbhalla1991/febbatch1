# Development Environment Configuration
include "root" {
  path = find_in_parent_folders()
}

# Environment-specific inputs
inputs = {
  environment   = "dev"
  aws_region    = "us-east-1"
  instance_type = "t2.micro"
  instance_count = 1
  
  tags = {
    Environment = "Development"
    CostCenter  = "Engineering"
  }
}
