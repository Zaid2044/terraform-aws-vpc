variable "project" {
  description = "Project name used for resource naming and tagging"
  type        = string

  validation {
    condition     = length(trimspace(var.project)) > 0
    error_message = "project cannot be empty."
  }
}

variable "environment" {
  description = "Environment name (e.g. dev, stage, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment must be one of: dev, stage, prod."
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
  description = "Availability zones keyed by logical name"

  type = map(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly 2 availability zones must be provided."
  }
}

variable "public_subnets" {
  description = "Public subnet CIDRs keyed by AZ"

  type = map(string)

  validation {
    condition     = length(var.public_subnets) == 2
    error_message = "Exactly 2 public subnets must be provided."
  }
}

variable "private_app_subnets" {
  description = "Private application subnet CIDRs keyed by AZ"

  type = map(string)

  validation {
    condition     = length(var.private_app_subnets) == 2
    error_message = "Exactly 2 private application subnets must be provided."
  }
}

variable "private_db_subnets" {
  description = "Private database subnet CIDRs keyed by AZ"

  type = map(string)

  validation {
    condition     = length(var.private_db_subnets) == 2
    error_message = "Exactly 2 private database subnets must be provided."
  }
}

variable "tags" {
  description = "Additional tags applied to all resources"

  type    = map(string)
  default = {}
}