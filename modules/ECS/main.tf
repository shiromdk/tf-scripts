provider "aws" {
  region = "ap-southeast-2"
  shared_config_files = ["C:/Users/c3131/.aws/config"]
  profile = "terraform"
}

module "load_balancer" {
  source = "./LoadBalancer"
}