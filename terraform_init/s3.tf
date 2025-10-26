resource "aws_s3_bucket" "terraform_backend" {
    bucket_prefix = "terraform-remote-state"
}

output "s3_bucket_name" {
    value = aws_s3_bucket.terraform_backend.bucket
}