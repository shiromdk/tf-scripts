resource "aws_ecs_service" "pt_ecs_service" {
  name = "PlayTodayECSService"
  cluster = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count = 1

  network_configuration {
    subnets = [aws_subnet.pt-public-subnet-1.id]
    security_groups = [ aws_security_group.ec2_ecs_instance.id]
  }
  force_new_deployment = true

  triggers = {
    redeployment = timestamp()
  }
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.pt-ecs-capacity-provider.name
    weight = 100
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.alb_public_webservice_target_group.arn
    container_name = "pt-ecs-image"
    container_port = 80
  } 
   depends_on = [aws_autoscaling_group.ecs_asg]
}