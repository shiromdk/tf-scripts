resource "aws_security_group" "external_load_balancer_sg" {
    name = "external-load-balancer-sg"
    description = "Security Group for external load balancer"

    ingress{
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb" "external_load_balancer" {
  name = "external-load-balancer"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.external_load_balancer_sg.id]
  subnets = [aws_vpc]
}



