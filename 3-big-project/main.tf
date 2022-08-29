terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Hard-coded credentials are not recommended in any Terraform 
# configuration and risks secret leakage should this file ever
# be committed to a public version control system.

# Configure the AWS Provider

provider "aws" {
  region     = "ap-south-1"
  access_key = "access_key"
  secret_key = "secret_key"
}


# 1. Create vpc

resource "aws_vpc" "secure-layer-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "secure-layer-vpc-tag"
  }
}

# 2. Create Internet Gateway --> So we can send traffic out to the internet, we assign a pubic IP to the server.

resource "aws_internet_gateway" "secure-layer-internet-gateway" {
  vpc_id = aws_vpc.secure-layer-vpc.id
  tags = {
    Name = "secure-layer-internet-gateway-tag"
  }
}

# 3. Create Custom Route Table --> Cool

resource "aws_route_table" "secure-layer-route-table" {
  vpc_id = aws_vpc.secure-layer-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secure-layer-internet-gateway.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.secure-layer-internet-gateway.id
  }

  tags = {
    Name = "secure-layer-route-table-tag"
  }
}


# 4. Create a Subnet

resource "aws_subnet" "secure-layer-subnet" {
  vpc_id            = aws_vpc.secure-layer-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "secure-layer-subnet-tag"
  }
}

# 5. Associate subnet with Route Table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.secure-layer-subnet.id
  route_table_id = aws_route_table.secure-layer-route-table.id
}

# 6. Create Security Group to allow port 22 ( SSH ) ,80 ( HTTP ),443 ( HTTPS )

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.secure-layer-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web-tag"
  }
}

# 7. Create a network interface with an ip in the subnet that was created in step 4

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.secure-layer-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}


# 8. Assign an elastic IP to the network interface created in step 7 --> Just a public IP

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [
    aws_internet_gateway.secure-layer-internet-gateway
  ]
}

output "server_public_ip" {
  value = aws_eip.one.public_ip
}

# 9. Create Ubuntu server and install/enable apache2

resource "aws_instance" "ec2-web-server" {
  ami               = "ami-068257025f72f470d"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name          = "ec2-ap-south-1a-main-key-pair"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF
  tags = {
    Name = "ec2-web-server-app-1"
  }
}

output "server_private_ip" {
  value = aws_instance.ec2-web-server.private_ip
}
output "server_id" {
  value = aws_instance.ec2-web-server.id
}
