terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws"{
    region = "ap-southeast-2"
    access_key = ""
    secret_key = ""
    
    default_tags {
    tags = {
      Environment = "Dev"
      Owner       = "Sandeep"
      Project     = "Terraform-Learning"
    }
  }

}

# VPC
resource "aws_vpc" "sandeep_vpc_test" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "sandeep-vpc-test"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.sandeep_vpc_test.id
  cidr_block             = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.sandeep_vpc_test.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw_test" {
  vpc_id = aws_vpc.sandeep_vpc_test.id

  tags = {
    Name = "sandeep-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.sandeep_vpc_test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_test.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rtb.id
}
