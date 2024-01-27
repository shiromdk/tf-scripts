resource "aws_s3_bucket" "logbucket"{
    bucket = "logsbucket.playtoday.cc"
      tags = {
    Name ="logsbucket.playtoday.cc"
  }
}

resource "aws_s3_bucket" "website" {
  bucket = var.subDomainName
  tags = {
    Name = "${var.subDomainName}"
  }
}
