provider "aws" {
  region = "ap-southeast-2"
  shared_config_files = ["C:/Users/c3131/.aws/config"]
  profile = "terraform"
}

provider "aws" {
  region = "us-east-1"
  shared_config_files = ["C:/Users/c3131/.aws/config"]
  profile = "terraform"
  alias = "us-east-1"
  
}

module "route53" {
  source = "./CloudfrontCert"
  providers = {
    aws = aws.us-east-1
  }
  SiteTags = var.SiteTags
  domainName = var.domainName
  subDomainName = var.subDomainName
}

module "cloudfront" {
  source ="./CloudfrontSetup"
  SiteTags = var.SiteTags
  domainName = var.domainName
  subDomainName = var.subDomainName
  certArn = module.route53.aws_acm_certificate_arn
}