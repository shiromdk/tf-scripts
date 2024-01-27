terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


data "aws_route53_zone" "public" {
  name         = var.domainName
  private_zone = false
}

resource "aws_acm_certificate" "static" {
  domain_name       = var.subDomainName
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Environment = var.SiteTags
  }
}



resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.static.domain_validation_options)[0].resource_record_name
  records         = [ tolist(aws_acm_certificate.static.domain_validation_options)[0].resource_record_value ]
  type            = tolist(aws_acm_certificate.static.domain_validation_options)[0].resource_record_type
  zone_id  = data.aws_route53_zone.public.id
  ttl      = 300
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.static.arn
  validation_record_fqdns = [ aws_route53_record.cert_validation.fqdn ]
}

output "aws_acm_certificate_arn" {
  description = "Certificate ARN"
  value = aws_acm_certificate_validation.cert.certificate_arn
}

output "aws_acm_validation_record_fqdns" {
  description = "Record FQDNS"
  value = aws_acm_certificate_validation.cert.validation_record_fqdns
}