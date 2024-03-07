# SSL Certificate
resource "aws_acm_certificate" "ssl_certificate" {
  provider                  = aws
  domain_name               = "*.playtoday.cc"
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
# SSL Certificate validation
resource "aws_acm_certificate_validation" "cert_validation" {
  provider        = aws
  certificate_arn = aws_acm_certificate.ssl_certificate.arn
}
