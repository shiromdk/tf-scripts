
resource "aws_lb" "external-load-balancer" {
  name = "external-load-balancer"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.external-load-balancer-sg.id]
  subnets = [aws_subnet.pt-public-subnet-1.id, aws_subnet.pt-public-subnet-2.id, aws_subnet.pt-public-subnet-3.id]
  depends_on = [ aws_internet_gateway.pt-igw ]
}


resource "aws_alb_target_group" "default-target-group" {
  name= "TargetGroup1"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.pt_vpc.id
  target_type = "ip"
  health_check {
    path = var.health_check_path
    # matcher             = "200"
  } 
}


resource "aws_lb_listener" "pt-front-end" {
  load_balancer_arn = aws_lb.external-load-balancer.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.default-target-group.arn
  }
}

