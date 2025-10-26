resource "aws_s3_bucket" "foundry_data_bucket" {
  for_each = toset(var.regions)

  bucket_prefix = "foundry-data-bucket-${each.key}-"

  region = each.key

  tags = {
    Name        = "Foundry Data Bucket"
  }
}

# TODO Implement Storage Tiering Policies after usage patterns are analyzed

output "names" {
    value = [for b in aws_s3_bucket.foundry_data_bucket : b.bucket]
}