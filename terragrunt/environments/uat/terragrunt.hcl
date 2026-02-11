# UAT Environment Configuration
include "root" {
  path = find_in_parent_folders()
}

# Environment-specific inputs
inputs = {
  environment   = "uat"
  aws_region    = "us-east-1"
  instance_type = "t2.small"
  instance_count = 2
  
  tags = {
    Environment = "UAT"
    CostCenter  = "Engineering"
  }
}
