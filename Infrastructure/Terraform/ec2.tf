resource "aws_security_group" "web_sb" {
    name = "wanderlust-sg"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        from_port = 9000
        to_port = 9000
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

resource "aws_key_pair" "web_key" {
    key_name = "wanderlust-key"
    public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "web_instance" {
    for_each = var.Jenkins
    ami = "ami-091138d0f0d41ff90"
    instance_type = each.value.instance_type
    key_name = aws_key_pair.web_key.key_name
    vpc_security_group_ids = [aws_security_group.web_sb.id]

    root_block_device {
      volume_size = each.value.volume_size
      volume_type = "gp3"
    }
    tags = {
        Name=each.value.node_name
    }
}

resource "aws_eip" "web_ip" {
  for_each = var.Jenkins
  instance = aws_instance.web_instance[each.key].id
  domain = "vpc"

  tags = {
    Name = "Static-IP-${each.value.node_name}"
  }
}

output "web_output" {
  value = {for key, instance in aws_instance.web_instance : key=>instance.public_ip}
}