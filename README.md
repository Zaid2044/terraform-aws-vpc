# Terraform AWS VPC Module

Reusable Terraform module for provisioning a highly available AWS VPC across two Availability Zones.

## Features

* VPC with DNS support and hostnames enabled
* Internet Gateway
* Public Subnets across 2 AZs
* Private Application Subnets across 2 AZs
* Private Database Subnets across 2 AZs
* Highly Available NAT Gateways (1 per AZ)
* Dedicated Route Tables
* Database subnet isolation
* Consistent tagging strategy
* Reusable module interface
* Semantic versioning support

## Architecture

```text
Internet
   │
   ▼
Internet Gateway
   │
   ▼
Public Route Table
   │
 ┌─┴────────────┐
 ▼              ▼
Public A     Public B
 │              │
 ▼              ▼
NAT A        NAT B
 │              │
 ▼              ▼
App A        App B

DB A         DB B
```

## Requirements

| Name         | Version  |
| ------------ | -------- |
| Terraform    | >= 1.8.0 |
| AWS Provider | ~> 6.0   |

## Usage

```hcl
module "vpc" {
  source = "git::https://github.com/<org>/terraform-aws-vpc.git?ref=v1.0.0"

  project     = "platform"
  environment = "dev"

  vpc_cidr = "10.0.0.0/16"

  availability_zones = {
    a = "ap-south-1a"
    b = "ap-south-1b"
  }

  public_subnets = {
    a = "10.0.1.0/24"
    b = "10.0.2.0/24"
  }

  private_app_subnets = {
    a = "10.0.11.0/24"
    b = "10.0.12.0/24"
  }

  private_db_subnets = {
    a = "10.0.21.0/24"
    b = "10.0.22.0/24"
  }
}
```

## Inputs

| Name                | Type        |
| ------------------- | ----------- |
| project             | string      |
| environment         | string      |
| vpc_cidr            | string      |
| availability_zones  | map(string) |
| public_subnets      | map(string) |
| private_app_subnets | map(string) |
| private_db_subnets  | map(string) |
| tags                | map(string) |

## Outputs

| Name                   |
| ---------------------- |
| vpc_id                 |
| internet_gateway_id    |
| public_subnet_ids      |
| private_app_subnet_ids |
| private_db_subnet_ids  |
| nat_gateway_ids        |
| availability_zones     |
| vpc_cidr               |

## Validation

The module is validated using:

* terraform fmt
* terraform validate
* tflint
* tfsec

## Versioning

This module follows Semantic Versioning.

Example:

* v1.0.0
* v1.1.0
* v2.0.0