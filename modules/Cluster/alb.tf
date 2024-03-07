##### ALB - Application Load Balancing #####
##### ALB - Load Balancer #####
resource "aws_lb" "loadbalancer" {
  internal           = "false" # internal = true else false
  name               = "pt-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.pt-public-subnet-1.id, aws_subnet.pt-public-subnet-2.id, aws_subnet.pt-public-subnet-3.id]
  security_groups    = [aws_security_group.public.id]
}

##### ALB - Target Groups #####


resource "aws_alb_target_group" "alb_public_webservice_target_group" {
  name     = "public-webservice-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.pt_vpc.id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "15"
    path                = "/"
    protocol            = "HTTP"
    unhealthy_threshold = "10"
    timeout             = "10"
  }
}
##### ALB - Listeners #####

resource "aws_lb_listener" "lb_listener-webservice-https-redirect" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "lb_listener-webservice-https" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.ssl_certificate.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_public_webservice_target_group.id
  }
}

