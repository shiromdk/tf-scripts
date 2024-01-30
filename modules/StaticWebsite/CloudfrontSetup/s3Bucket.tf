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


resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website-cdn-cf-policy.json
}

data "aws_iam_policy_document" "website-cdn-cf-policy" {
  statement {
    sid = "AllowCloudFrontServicePrincipal"
	  principals {
			type        = "Service"
			identifiers = ["cloudfront.amazonaws.com"]
		}
    condition {
			test     = "StringEquals"
			variable = "AWS:SourceArn"
			values   = [aws_cloudfront_distribution.s3_distribution.arn]
		}
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.website.arn}/*"
    ]
  }
  	statement {
		actions   = ["s3:GetObject"]
		resources = ["${aws_s3_bucket.website.arn}/*"]

		principals {
			type        = "AWS"
			identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
		}
	}
}