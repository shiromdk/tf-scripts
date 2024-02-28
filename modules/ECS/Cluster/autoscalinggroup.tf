resource "aws_autoscaling_group" "ecs_asg" {
    name = "PlayTodayASG"
    min_size = 1
    max_size = 3

    vpc_zone_identifier = [aws_subnet.pt-public-subnet-1.id]
    desired_capacity    = 2

    launch_template {
      id = aws_launch_template.ecs_lt.id
      version = "$Latest"
    }
    tag {
        key                 = "AmazonECSManaged"
        value               = true
        propagate_at_launch = true
    }
}

