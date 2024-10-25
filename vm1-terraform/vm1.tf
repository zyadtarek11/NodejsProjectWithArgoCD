provider "aws" {
  region = "eu-west-3"
  access_key = "...."
  secret_key = "...."
}

# Creating VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dev-vpc.id
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Create Subnet1 for Jenkins EC2
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Create Subnet2 for ArgoCD EC2
resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = true
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "subnet1_association" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id = aws_subnet.subnet2.id
  route_table_id = aws_route_table.public.id
}

# Create a Security Group
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.dev-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Security Group"
  }
}

# Creating the EC2 Instance for Jenkins in Subnet1
resource "aws_instance" "jenkins" {
  ami = "ami-00d81861317c2cc1f" # Amazon linux 2023 AMI
  instance_type = "t3.medium"
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  key_name = "jenkins-key"
  # Block device configuration for the root volume
  root_block_device {
    delete_on_termination = false  # Set to 'false' to keep the root volume after instance termination
    volume_size = 12  # Set root volume size to 12 GB
  }
  tags = {
    Name = "Jenkins Instance"
  }
}

# Creating the EC2 Instance for ArgoCD in Subnet2
resource "aws_instance" "argocd" {
  ami = "ami-00d81861317c2cc1f" # Amazon linux 2023 AMI
  instance_type = "t3.medium"
  subnet_id = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  key_name = "argocd-key"
  # Block device configuration for the root volume
  root_block_device {
    delete_on_termination = false  # Set to 'false' to keep the root volume after instance termination
    volume_size = 12  # Set root volume size to 12 GB
  }
  tags = {
    Name = "ArgoCD Instance"
  }
}

