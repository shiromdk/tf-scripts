resource "aws_autoscaling_group" "ecs_asg" {
    name = "PlayTodayASG"
    min_size = 1
    max_size = 3

    vpc_zone_identifier = [aws_subnet.pt-public-subnet-1]
    desired_capacity    = 2

}