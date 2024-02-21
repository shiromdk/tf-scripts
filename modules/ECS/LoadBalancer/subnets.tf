resource "aws_subnet" "pt-public-subnet-1" {
  tags = {
    Name = "Play Today Public Subnet 1"
  }
  vpc_id = aws_vpc.pt_vpc.id
  cidr_block = var.public_subnet_1_cidr
  availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "pt-public-subnet-2" {
  tags = {
    Name = "Play Today Public Subnet 2"
  }
  vpc_id = aws_vpc.pt_vpc.id
  cidr_block = var.public_subnet_2_cidr
  availability_zone = var.availability_zones[1]
}
resource "aws_subnet" "pt-public-subnet-3" {
  tags = {
    Name = "Play Today Public Subnet 3"
  }
  vpc_id = aws_vpc.pt_vpc.id
  cidr_block = var.public_subnet_3_cidr
  availability_zone = var.availability_zones[2]
}
resource "aws_subnet" "pt-private-subnet-1" {
  tags = {
      Name = "Play Today Private Subnet 1"
  }
  vpc_id = aws_vpc.pt_vpc.id
  cidr_block = var.private_subnet_1_cidr
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

# Route the public subnet traffic through the Internet Gateway
resource "aws_route" "public-internet-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.pt-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Route Nat Gateway

resource "aws_route" "private-route" {
  route_table_id = aws_route_table.private-route-table.id
  gateway_id = aws_nat_gateway.pt-ngw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Associate the newly created route tables to the subnets
resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.pt-public-subnet-1.id
}

resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.pt-private-subnet-1.id
}