# Read data from another state file stored in S3
data "terraform_remote_state" "other_project" {
  backend = "s3"
  
  config = {
   bucket         = "my-terraform-state-1991"
    key            = "terraform/state/sg.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

