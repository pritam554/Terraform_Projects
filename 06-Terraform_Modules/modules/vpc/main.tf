resource "aws_vpc" "pbanik_custom_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "pbanik - Custom VPC"
  }
}

resource "aws_subnet" "pbanik_public_subnet" {
  vpc_id            = aws_vpc.pbanik_custom_vpc.id
  cidr_block        = var.public_sub_1_cidr

  tags = {
    Name = "pbanik - Public Subnet"
  }
}

resource "aws_subnet" "pbanik_private_subnet" {
  vpc_id            = aws_vpc.pbanik_custom_vpc.id
  cidr_block        = var.private_sub_1_cidr

  tags = {
    Name = "pbanik - Private Subnet"
  }
}

resource "aws_internet_gateway" "pbanik_igw" {
  vpc_id = aws_vpc.pbanik_custom_vpc.id

  tags = {
    Name = "pbanik - Internet Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.pbanik_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pbanik_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.pbanik_igw.id
  }

  tags = {
    Name = "pbanik - Route Table"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.pbanik_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "public_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.pbanik_custom_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

