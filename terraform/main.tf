 resource "aws_s3_bucket" "s3example" {
  bucket = var.bucket_name

  tags = {
    Name        = "ExampleBucket"
    Environment = "prod"
  }
 }
