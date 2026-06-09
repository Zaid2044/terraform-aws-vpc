terraform {
  required_version = ">= 1.8.0"
}

provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "../../"

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