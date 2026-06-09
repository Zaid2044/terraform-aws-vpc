output "vpc_id" {
  description = "VPC ID"

  value = aws_vpc.this.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"

  value = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"

  value = {
    for key, subnet in aws_subnet.public :
    key => subnet.id
  }
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs"

  value = {
    for key, subnet in aws_subnet.private_app :
    key => subnet.id
  }
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs"

  value = {
    for key, subnet in aws_subnet.private_db :
    key => subnet.id
  }
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"

  value = {
    for key, nat in aws_nat_gateway.this :
    key => nat.id
  }
}

output "availability_zones" {
  description = "Availability zones used by the VPC"

  value = var.availability_zones
}

output "vpc_cidr" {
  description = "VPC CIDR block"

  value = aws_vpc.this.cidr_block
}