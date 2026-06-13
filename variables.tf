variable "project" {
  description = "Project name used for resource naming and tagging"
  type        = string

  validation {
    condition     = length(trimspace(var.project)) > 0
    error_message = "Project name cannot be empty."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "stage", "prod"], lower(var.environment))
    error_message = "Environment must be one of: dev, stage, prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}

variable "availability_zones" {
  description = "List of Availability Zones"

  type = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least 2 Availability Zones must be provided."
  }
}

variable "public_subnets" {
  description = "Map of public subnet CIDRs"

  type = map(string)

  validation {
    condition = alltrue([
      for cidr in values(var.public_subnets) :
      can(cidrhost(cidr, 0))
    ])
    error_message = "All public subnet CIDRs must be valid."
  }
}

variable "private_app_subnets" {
  description = "Map of private application subnet CIDRs"

  type = map(string)

  validation {
    condition = alltrue([
      for cidr in values(var.private_app_subnets) :
      can(cidrhost(cidr, 0))
    ])
    error_message = "All private application subnet CIDRs must be valid."
  }
}

variable "private_db_subnets" {
  description = "Map of private database subnet CIDRs"

  type    = map(string)
  default = {}

  validation {
    condition = alltrue([
      for cidr in values(var.private_db_subnets) :
      can(cidrhost(cidr, 0))
    ])
    error_message = "All database subnet CIDRs must be valid."
  }
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway"

  type    = bool
  default = false
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"

  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"

  type    = bool
  default = true
}

variable "tags" {
  description = "Additional tags applied to all resources"

  type    = map(string)
  default = {}
}