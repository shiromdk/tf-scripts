provider "aws" {
  region = "ap-southeast-2"
  shared_config_files = ["C:/Users/c3131/.aws/config"]
  profile = "terraform"
}

provider "aws" {
  region = "us-east-1"
  shared_config_files = ["C:/Users/c3131/.aws/config"]
  profile = "terraform"
  alias = "us-east"
}

locals {
  name     = "play-today"
  region   = "ap-southeast-2"
}
# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.5.2"

#   name = local.name
#   cidr = "10.99.0.0/18"

#   azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
#   public_subnets   = ["10.99.0.0/24", "10.99.1.0/24", "10.99.2.0/24"]
#   private_subnets  = ["10.99.3.0/24"]

# #   create_database_subnet_group = true
#   enable_dns_hostnames         = true

#   enable_nat_gateway  = true
#   single_nat_gateway  = true
#   reuse_nat_ips       = true
#   external_nat_ip_ids = [aws_eip.eip_nat.id]

# }

