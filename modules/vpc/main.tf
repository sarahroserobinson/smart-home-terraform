resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_range

  tags = {
    Name = var.vpc_name
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw_${var.vpc_name}"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${var.availability_zones[count.index]}"
  }
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-private-${var.availability_zones[count.index]}"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-route-table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnets)
  route_table_id = aws_route_table.route_table.id
  subnet_id      = element(aws_subnet.public[*].id, count.index)
}


resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.route_table.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

