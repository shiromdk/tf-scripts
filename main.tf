provider "aws" {
  region = "ap-southeast-2"
  shared_config_files = ["C:/Users/c3131/.aws/config"]
  profile                  = "terraform"
}

module "cloudfront" {
  source ="./modules/SampleReactStatic/"
  SiteTags = var.SiteTags
  domainName = var.domainName
  subDomainName = var.subDomainName
}