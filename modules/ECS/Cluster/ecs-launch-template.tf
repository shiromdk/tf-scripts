resource "aws_launch_template" "ecs_lt" {
 name_prefix   = "ecs-template"
 image_id      = "ami-07e1aeb90edb268a3"
 instance_type = "t3.micro"
 vpc_security_group_ids = [aws_security_group.ec2-sg.id]
 iam_instance_profile {
   arn = aws_iam_instance_profile.ecsInstanceRole_profile.arn
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
  depends_on = [ aws_iam_role.ecsInstanceRole ]
  user_data = filebase64("${path.module}/ecs.sh")
}