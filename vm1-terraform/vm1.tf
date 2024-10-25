provider "aws" {
  region     = "us-west-3"
  access_key = env("my-access-key")
  secret_key = env("my-secret-key")
}

# Creating the EC2 Instance

resource "aws_instance" "jenkins" {
  ami                     = "ami-005fc0f236362e99f" # Ubuntu 22.04 LTS
  instance_type           = "t2.micro"
  tags = {
    Name = "admin"
  }
}

# Creating VPC

resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dev-vpc.id
}