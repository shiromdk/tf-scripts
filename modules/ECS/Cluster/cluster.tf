resource "aws_ecs_cluster" "pt-ecs-cluster" {
 name = "PlayTodayCluster"
}

resource "aws_ecs_capacity_provider" "pt-ecs-capacity-provider" {
  name ="PlayTodayCapacityProvider"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn
    managed_scaling {
     maximum_scaling_step_size = 1000
     minimum_scaling_step_size = 1
     status                    = "ENABLED"
     target_capacity           = 1
   }
  }
}


resource "aws_ecs_cluster_capacity_providers" "pt_aeccp" {
  cluster_name = aws_ecs_cluster.pt-ecs-cluster.name
  capacity_providers = [ aws_ecs_capacity_provider.pt-ecs-capacity-provider.name]

    default_capacity_provider_strategy {
      base = 1
      weight = 100
      capacity_provider = aws_ecs_capacity_provider.pt-ecs-capacity-provider.name
    }   
}