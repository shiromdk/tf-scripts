# terraform {
#   backend "s3" {
#     bucket = "terraform.state.playtoday.cc"
#     key    = "testabc.playtoday.cc/terraform.tfstate"
#     region = "ap-southeast-2"
#   }
# }
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
#   subDomainName = "testabc.playtoday.cc"
# }

# output "cloudfront_distribution_id" {
#   value = module.cloudfront_sites.cloudfront_distribution_id
# }
module "ecs" {
  source = "./modules/ECS"
}