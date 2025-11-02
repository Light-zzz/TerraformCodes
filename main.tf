# Selecting AWS Provider
provider "aws" {
  region = "ap-south-1" # Replace with your desired AWS region
}

# Creating VPC
resource "aws_vpc" "VPC_Terraform" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.VPC_Terraform
  }
}

# Creating Public Subnet
resource "aws_subnet" "Sub_Pub" {
  vpc_id     = aws_vpc.VPC_Terraform.id
  cidr_block = var.Sub_Pub
  availability_zone = "ap-south-1a"
  depends_on = [ aws_vpc.VPC_Terraform ]
  tags = {
    Name = "Public_subnet"
  }
}

# Creating Private Subnet
resource "aws_subnet" "Sub_Pri" {
  vpc_id     = aws_vpc.VPC_Terraform.id
  cidr_block = var.Sub_Pri
  availability_zone = "ap-south-1b"
  depends_on = [ aws_vpc.VPC_Terraform ]
  tags = {
    Name = "Private_subnet"
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "Pub_IGW" {
  vpc_id = aws_vpc.VPC_Terraform.id

  tags = {
    Name = "Public_IGW"
  }
}

# Creating Public Route Table
resource "aws_route_table" "pub_route" {
  vpc_id = aws_vpc.VPC_Terraform.id
  

  tags = {
    Name = "public_route"
  }
}

# Creating Private Route Table
resource "aws_route_table" "pri_route" {
  vpc_id = aws_vpc.VPC_Terraform.id

  tags = {
    Name = "private_route"
  }
}

# Internet Route for Public Subnet
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.pub_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Pub_IGW.id

  depends_on = [aws_internet_gateway.Pub_IGW]
}

# Associating Subnets with Route Tables
resource "aws_route_table_association" "pub_subnet_association" {
  subnet_id      = aws_subnet.Sub_Pub.id
  route_table_id = aws_route_table.pub_route.id
}

resource "aws_route_table_association" "pri_subnet_association" {
  subnet_id      = aws_subnet.Sub_Pri.id
  route_table_id = aws_route_table.pri_route.id
}

# Creating Security Group for EC2 Instance
resource "aws_security_group" "EC2_SG" {
  vpc_id      = aws_vpc.VPC_Terraform.id
  name        = "ec2-security-group"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
  description = "Allow HTTP traffic"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
}
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2_SG"
  }
}

# # Creating EC2 Instance in Public Subnet
# resource "aws_instance" "public_ec2_instance" {
#   ami               = "ami-02d26659fd82cf299" # Example AMI for Amazon Linux 2
#   instance_type     = "t2.micro"
#   associate_public_ip_address = true
#   subnet_id         = aws_subnet.Sub_Pub.id
#   vpc_security_group_ids = [aws_security_group.EC2_SG.id]
#   key_name          = "JekinsKey" # Replace with your actual EC2 key pair name

#   tags = {
#     Name = var.public_ec2_instance
#   }
# }

resource "aws_instance" "web_server1" {
  ami           = "ami-01760eea5c574eb86" # Example Amazon Linux 2 AMI (update as needed)
  instance_type = "t2.micro"
  key_name      = "JekinsKey"
  associate_public_ip_address = true
  subnet_id = aws_subnet.Sub_Pub.id
  vpc_security_group_ids = [aws_security_group.EC2_SG.id]

  # The user_data script runs on instance startup
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install nginx -y
              sudo systemctl enable nginx
              sudo systemctl start nginx
              echo "<h1>Welcome to NGINX on AWS EC2 - via Terraform!</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "Terraform-NGINX-Server222"
  }
}