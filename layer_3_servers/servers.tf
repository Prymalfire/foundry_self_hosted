data "aws_ssm_parameter" "al2023_ami" {
  for_each = local.regions
  region = each.key
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_ami" "al2023" {
  for_each = local.regions
  region = each.key
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "image-id"
    values = [data.aws_ssm_parameter.al2023_ami[each.key].value]
  }
}

resource aws_instance "foundry_server" {
  for_each = local.servers
  ami           = data.aws_ami.al2023[each.value.region].id
  instance_type = "t3.micro"

  iam_instance_profile = aws_iam_instance_profile.foundry_server_instance_profile.name

  region = each.value.region
  vpc_security_group_ids      = [data.terraform_remote_state.networking.outputs.security_group_id[each.value.region]]
  key_name                    = local.key_name
  associate_public_ip_address = true

  tags = {
    Name = "FoundryVTTServer-${each.key}"
  }

  

  depends_on = [ aws_key_pair.admin_key_pair ]
}