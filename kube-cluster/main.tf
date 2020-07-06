provider "aws" {
  region = var.aws_region[1]
}
locals {
  common_tags = {
    Name = "Master"
    user = "Rohan"
    env  = "Stage"
  }
}
# instance
resource "aws_instance" "my-test-instance" {
  ami                    = lookup(var.amis, var.aws_region[1])
  instance_type          = var.instance_type[2]
  subnet_id              = aws_subnet.main-public-1.id
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  key_name               = "Mumbai"
  tags                   = local.common_tags

  provisioner "local-exec" {
    command = "echo [master] >> ./stage_hosts"
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.my-test-instance.public_ip} >> ./stage_hosts"
  }


}
# instance
resource "aws_instance" "my-test-instance2" {
  ami                    = lookup(var.amis, var.aws_region[1])
  instance_type          = var.instance_type[0]
  subnet_id              = aws_subnet.main-public-1.id
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  key_name               = "Mumbai"
  tags = {
    Name = "Worker"
    user = "Rohan"
    env  = "Stage"
  }

  provisioner "local-exec" {
    command = "echo [worker] >> ./stage_hosts"
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.my-test-instance2.public_ip} >> ./stage_hosts"
  }


}
# security group
resource "aws_security_group" "allow-ssh" {
  vpc_id = aws_vpc.main.id
  name   = "terraform-sg"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# vpc
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block_vpc
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags                 = local.common_tags
}


# Subnets
resource "aws_subnet" "main-public-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block_public
  map_public_ip_on_launch = var.map_public_ip_on_launch_public
  availability_zone       = lookup(var.azs, var.aws_region[1])[0]
  tags                    = local.common_tags
}

resource "aws_subnet" "main-private-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block_private
  map_public_ip_on_launch = var.map_public_ip_on_launch_private
  availability_zone       = lookup(var.azs, var.aws_region[1])[1]
  tags                    = local.common_tags
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id
  tags   = local.common_tags
}

# route tables
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "${aws_instance.my-test-instance.public_ip}/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }
  route {
    cidr_block = "${aws_instance.my-test-instance2.public_ip}/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = local.common_tags
}

# Route table association
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.main-public-1.id
  route_table_id = aws_route_table.main-public.id
  provisioner "local-exec" {
    command = "sleep 60; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./Mumbai.pem -i ./stage_hosts ./dependencies.yml"
  }
}

terraform {
  required_providers {
    aws = "~>2.65.0"
  }
}
