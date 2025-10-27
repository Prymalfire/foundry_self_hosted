resource "tls_private_key" "admin_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  key_name = "admin-key"
}

resource "aws_key_pair" "admin_key_pair" {
  for_each = local.regions
  region = each.key
  key_name   = local.key_name
  public_key = tls_private_key.admin_key.public_key_openssh
}

output "private_key" {
  value     = tls_private_key.admin_key.private_key_pem
  sensitive = true
}