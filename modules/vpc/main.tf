resource "aws_vpc" "netflix_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "netflix-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.netflix_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true 

  tags = {
    Name = "netflix-public-subnet"
  }
}

resource "aws_internet_gateway" "netflix_igw" {
  vpc_id = aws_vpc.netflix_vpc.id

  tags = {
    Name = "netflix-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.netflix_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.netflix_igw.id
  }

  tags = {
    Name = "netflix-public-rt"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "netflix_sg" {
  name        = "netflix-sg"
  description = "Security group for Netflix clone"
  vpc_id      = aws_vpc.netflix_vpc.id

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

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SonarQube"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    description = "Netflix"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "netflix-sg"
  }
}