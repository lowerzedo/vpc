resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "private_subnets" {
  vpc_id   = aws_vpc.vpc.id
  for_each = toset(var.private_subnets)
  id       = each.key
}

resource "aws_subnet" "public_subnets" {
  vpc_id   = aws_vpc.vpc.id
  for_each = toset(var.public_subnets)
  id       = each.key
}

resource "aws_internet_gateway" "terraform-igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_eip" "terraform-eip-ngw" {

  depends_on = [aws_internet_gateway.terraform-igw]
}

resource "aws_nat_gateway" "terraform-ngw" {
  subnet_id = aws_subnet.private_subnets
  for_each  = public_subnets
  id        = each.id
}
