##### ECS-Cluster #####
resource "aws_ecs_cluster" "cluster" {
  name = "ecs-pt-cluster"
}


resource "aws_ecs_service" "pt-ecs-service" {
    name = "PlayTodayECSService"
    cluster = aws_ecs_cluster.cluster.id
    task_definition = aws_ecs_task_definition.task_definition.arn
    desired_count = 1

    network_configuration {
        subnets = [aws_subnet.pt-public-subnet-1.id, aws_subnet.pt-public-subnet-2.id,aws_subnet.pt-public-subnet-3.id]
    security_groups = [ aws_security_group.ec2_ecs_instance.id]
    }
    force_new_deployment = true
    placement_constraints {
        type       = "memberOf"
        expression = "attribute:ecs.availability-zone in [ap-southeast-2a, ap-southeast-2b,ap-southeast-2c]"
    } 

    load_balancer {
      target_group_arn = aws_alb_target_group.alb_public_webservice_target_group.arn
      container_name = "pt-ecs-image"
       container_port = 80
    }
}

##### AWS ECS-TASK #####
resource "aws_ecs_task_definition" "task_definition" {

  family                   = "pt-task-definition-webservice"            # task name
  network_mode             = "awsvpc"                                         # network mode awsvpc, brigde
  memory                   = "512"
  cpu                      = "256"
  requires_compatibilities = ["EC2"] # Fargate or EC2

  container_definitions = jsonencode([
   {
     name      = "pt-ecs-image"
     image     = "nginx:latest"
     cpu       = 256
     memory    = 512
     essential = true
     portMappings = [
       {
         containerPort = 80
         hostPort      = 80
         protocol      = "tcp"
       }
     ]
   }
 ])
}

data "template_file" "task_definition_json" {
  template = file("task_definition.json")

  vars = {
    CONTAINER_IMAGE = var.container_image
  }
}

resource "aws_ecs_capacity_provider" "pt-ecs-capacity-provider" {
  name ="PlayTodayCapacityProvider"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn
    managed_scaling {
     maximum_scaling_step_size = 1000
     minimum_scaling_step_size = 1
     status                    = "ENABLED"
     target_capacity           = 3
   }
  }
}


resource "aws_ecs_cluster_capacity_providers" "pt_aeccp" {
  cluster_name = aws_ecs_cluster.cluster.name
  capacity_providers = [ aws_ecs_capacity_provider.pt-ecs-capacity-provider.name]

    default_capacity_provider_strategy {
      base = 1
      weight = 100
      capacity_provider = aws_ecs_capacity_provider.pt-ecs-capacity-provider.name
    }   
}