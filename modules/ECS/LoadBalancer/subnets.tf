resource "aws_subnet" "pt-public-subnet-1" {
  tags = {
    Name = "Play Today Public Subnet 1"
  }
  vpc_id = aws_vpc.pt_vpc.id
  cidr_block = var.public_subnet_1_cidr
  availability_zone = var.availability_zones[0]
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "pt-igw" {
  tags = {
    Name = "Play Today Internet Gateway"
  }
  vpc_id = aws_vpc.pt_vpc.id
}

// NAT Gateway
resource "aws_eip" "pt-ngw-eip" {
  domain = "vpc"
  associate_with_private_ip = "10.0.0.5"
  depends_on = [ aws_internet_gateway.pt-igw ]
}

resource "aws_nat_gateway" "pt-ngw" {
  allocation_id = aws_eip.pt-ngw-eip.id
  subnet_id = aws_subnet.pt-public-subnet-1.id
  tags = {
    Name = "Play Today NAT Gateway"
  }
  depends_on = [ aws_eip.pt-ngw-eip ]
}

// Route tables for Subnets
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.pt_vpc.id
  tags = {
    Name = "Play Today Public Route Table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.pt_vpc.id
  tags = {
    Name = "Play Today Private Route Table"
  }
}