resource "aws_s3_bucket" "foundry_data_bucket" {
  for_each = local.regions

  bucket_prefix = "foundry-data-bucket-${each.key}-"

  region = each.key

  tags = {
    Name        = "Foundry Data Bucket"
  }
}

# TODO Implement Storage Tiering Policies after usage patterns are analyzed

output "foundry_data_buckets" {
  description = "Map of S3 bucket names and ARNs by region"
  value = {
    for region, bucket in aws_s3_bucket.foundry_data_bucket :
    region => {
      name = bucket.bucket
      arn  = bucket.arn
    }
  }
}