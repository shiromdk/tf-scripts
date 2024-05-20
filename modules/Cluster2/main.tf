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
