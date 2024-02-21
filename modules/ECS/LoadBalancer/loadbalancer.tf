
resource "aws_lb" "external_load_balancer" {
  name = "external-load-balancer"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.external_load_balancer_sg.id]
  subnets = [aws_vpc]
}


resource "aws_alb_target_group" "default-target-group" {
  name= "Target Group 1"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.pt_vpc.id

  health_check {
    path = var.health_check_path
    port = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout        = 2
    interval            = 60
    matcher             = "200"
  } 
}

resource "aws_autoscaling_attachment" "pt-autoscaling-attachment" {
  autoscaling_group_name = aws_auto
}