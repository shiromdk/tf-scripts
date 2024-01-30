locals {
  s3_origin_id = "myS3Origin"
}

data "aws_cloudfront_cache_policy" "cache-optimized" {
  name = "Managed-CachingOptimized"
}
resource "aws_cloudfront_origin_access_control" "cf_oac" {
  name                              = "Website"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cf_oac.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  aliases = [var.subDomainName]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    compress = true
    cache_policy_id = data.aws_cloudfront_cache_policy.cache-optimized.id
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    acm_certificate_arn = var.certArn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }

  custom_error_response {
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
    error_caching_min_ttl = 60
  }
    custom_error_response {
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
    error_caching_min_ttl = 60
  }
}