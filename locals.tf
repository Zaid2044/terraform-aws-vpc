locals {
  name_prefix = "${var.project}-${var.environment}"

  common_tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "Terraform"
      Module      = "vpc"
    },
    var.tags
  )

  public_subnet_config = {
    for key, cidr in var.public_subnets : key => {
      cidr = cidr
      az   = var.availability_zones[key]
      name = "${local.name_prefix}-public-subnet-${key}"
    }
  }

  private_app_subnet_config = {
    for key, cidr in var.private_app_subnets : key => {
      cidr = cidr
      az   = var.availability_zones[key]
      name = "${local.name_prefix}-private-app-subnet-${key}"
    }
  }

  private_db_subnet_config = {
    for key, cidr in var.private_db_subnets : key => {
      cidr = cidr
      az   = var.availability_zones[key]
      name = "${local.name_prefix}-private-db-subnet-${key}"
    }
  }

  vpc_name = "${local.name_prefix}-vpc"

  igw_name = "${local.name_prefix}-igw"

  public_route_table_name  = "${local.name_prefix}-public-rt"
  private_route_table_name = "${local.name_prefix}-private-rt"
}