output "vpc_id" {
  description = "ID of the VPC"

  value = aws_vpc.this.id
}

output "vpc_arn" {
  description = "ARN of the VPC"

  value = aws_vpc.this.arn
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"

  value = aws_vpc.this.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"

  value = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  description = "Map of public subnet IDs"

  value = {
    for key, subnet in aws_subnet.public :
    key => subnet.id
  }
}

output "private_app_subnet_ids" {
  description = "Map of private application subnet IDs"

  value = {
    for key, subnet in aws_subnet.private_app :
    key => subnet.id
  }
}

output "public_route_table_id" {
  description = "Public route table ID"

  value = aws_route_table.public.id
}

output "private_app_route_table_ids" {
  description = "Map of private route table IDs"

  value = {
    for key, rt in aws_route_table.private_app :
    key => rt.id
  }
}

output "nat_gateway_ids" {
  description = "Map of NAT Gateway IDs"

  value = {
    for key, nat in aws_nat_gateway.this :
    key => nat.id
  }
}

output "availability_zones" {
  description = "Availability Zones used"

  value = var.availability_zones
}