resource "aws_vpc" "pt_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "Play Today VPC" 
  }
}
