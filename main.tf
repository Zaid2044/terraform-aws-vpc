resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    local.common_tags,
    {
      Name = local.vpc_name
    }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = local.igw_name
    }
  )
}

resource "aws_subnet" "public" {
  for_each = local.public_subnet_config

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = each.value.name
      Tier = "public"
    }
  )
}

resource "aws_subnet" "private_app" {
  for_each = local.private_app_subnet_config

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    local.common_tags,
    {
      Name = each.value.name
      Tier = "private-app"
    }
  )
}

resource "aws_eip" "nat" {
  for_each = var.enable_nat_gateway ? local.public_subnet_config : {}

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nat-eip-${each.key}"
    }
  )
}

resource "aws_nat_gateway" "this" {
  for_each = var.enable_nat_gateway ? local.public_subnet_config : {}

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nat-${each.key}"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = local.public_route_table_name
    }
  )
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.this.id
}

resource "aws_route_table" "private_app" {
  for_each = local.private_app_subnet_config

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-app-rt-${each.key}"
    }
  )
}

resource "aws_route" "private_app_internet" {
  for_each = var.enable_nat_gateway ? local.private_app_subnet_config : {}

  route_table_id         = aws_route_table.private_app[each.key].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.this[each.key].id

  depends_on = [
    aws_nat_gateway.this
  ]
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_app" {
  for_each = aws_subnet.private_app

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app[each.key].id
}