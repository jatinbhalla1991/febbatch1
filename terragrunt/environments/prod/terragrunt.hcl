# Production Environment Configuration
include "root" {
  path = find_in_parent_folders()
}

# Environment-specific inputs
inputs = {
  environment   = "prod"
  aws_region    = "us-east-1"
  instance_type = "t3.medium"
  instance_count = 3
  
  tags = {
    Environment = "Production"
    CostCenter  = "Operations"
  }
}
