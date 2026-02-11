
 resource "aws_instance" "example" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "Instance-${count.index + 1}"
    Environment = "prod"
  }
}
