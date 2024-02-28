resource "aws_launch_template" "ecs_lt" {
 name_prefix   = "ecs-template"
 image_id      = "ami-07e1aeb90edb268a3"
 instance_type = "t3.micro"

 key_name               = "ec2ecsglog"
 vpc_security_group_ids = [aws_security_group.ec2-sg.id]
 iam_instance_profile {
   name = "ecsInstanceRole"
 }

 block_device_mappings {
   device_name = "/dev/xvda"
   ebs {
     volume_size = 30
     volume_type = "gp2"
   }
 }

 tag_specifications {
   resource_type = "instance"
   tags = {
     Name = "ecs-instance"
   }
 }

#  user_data = filebase64("${path.module}/ecs.sh")
}