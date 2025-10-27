data aws_vpc default {
    for_each = {for region in var.regions : region => region}
    default = true
    region = each.key
}

resource "aws_security_group" "foundry_web" {
    for_each = data.aws_vpc.default
    name        = "foundry-web-server-group"
    description = "Security group for Foundry VTT web servers"
    vpc_id      = data.aws_vpc.default[each.key].id
    region = each.key

    // HTTP
    ingress {
        description      = "HTTP"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    // HTTPS
    ingress {
        description      = "HTTPS"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    // Foundry default client port (TCP)
    ingress {
        description      = "Foundry client port (TCP)"
        from_port        = 30000
        to_port          = 30000
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    // SSH for administrators (restrict to admin CIDR)
    ingress {
        description = "SSH from admin network"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // Allow all outbound
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "foundry-web-group-${each.key}"
    }
}