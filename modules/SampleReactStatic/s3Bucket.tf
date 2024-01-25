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

resource "aws_s3_bucket_acl" "website_acl" {
  bucket = aws_s3_bucket.website.id
  acl = "private"
}

