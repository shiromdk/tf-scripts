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

# module "cloudfront_sites" {
#   source = "./modules/StaticWebsite"
#   SiteTags = var.SiteTags
#   domainName = var.domainName
#   subDomainName = "testtf.playtoday.cc"
# }