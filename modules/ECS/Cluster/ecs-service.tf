resource "aws_ecs_service" "pt_ecs_service" {
  name = "PlayTodayECSService"
  cluster = aws_ecs_cluster.pt-ecs-cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count = 1

  network_configuration {
    subnets = [aws_subnet.pt-public-subnet-1.id]
    security_groups = [ aws_security_group.ec2-sg.id]
  }
  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  } 
  triggers = {
    redeployment = timestamp()
  }
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.pt-ecs-capacity-provider.name
    weight = 100
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.default-target-group.arn
    container_name = "hello-world"
    container_port = 80
  } 
   depends_on = [aws_autoscaling_group.ecs_asg]
}