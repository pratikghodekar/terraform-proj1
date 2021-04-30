resource "aws_vpc" "dev" {
  cidr_block       = var.cidr_block

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = var.public_subnet1_cidr
  availability_zone = var.public_subnet1_availability_zone

  tags = {
    Name = "public"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = var.public_subnet2_cidr
  availability_zone = var.public_subnet2_availability_zone

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.private_subnet_availability_zone

  tags = {
    Name = "private"
  }
}

resource "aws_internet_gateway" "dev_gateway" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev"
  }
}

resource "aws_eip" "dev_nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "dev_nat" {
  allocation_id = aws_eip.dev_nat_eip.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "dev NAT"
  }
}

resource "aws_route_table" "igw_route_table" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.dev_gateway.id
  }

  tags = {
    Name = "igw_route_table"
  }
}

resource "aws_route_table_association" "igw_route_table_public1_subnet_association" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.igw_route_table.id
}

resource "aws_route_table_association" "igw_route_table_public2_subnet_association" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.igw_route_table.id
}

resource "aws_route_table" "nat_route_table" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.dev_nat.id
  }  

  tags = {
    Name = "nat_route_table"
  }
}

resource "aws_route_table_association" "nat_route_table_private_subnet_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.nat_route_table.id
}