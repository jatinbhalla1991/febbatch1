module "instance" {
  source = "../terraformmodules/instance"

  ami_id         = var.ami_id
  instance_type   = var.instance_type
  instance_count  = var.instance_count
  
}

# module "s3" {
#   source = "../terraformmodules/s3"
#   bucket_name = var.bucket_name
# }