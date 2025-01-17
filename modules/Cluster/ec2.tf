##### AWS EC2 ##### 
resource "aws_instance" "ec2_instance" {
  ami                    = "ami-07e1aeb90edb268a3"
  subnet_id              = aws_subnet.pt-private-subnet-1.id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ecs_agent.name
  vpc_security_group_ids = [aws_security_group.ec2_ecs_instance.id]
  ebs_optimized          = "false"
  source_dest_check      = "false"
  user_data              = data.template_file.user_data.rendered
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = "true"
  }
}
data "template_file" "user_data" {
  template = file("user_data.tpl") #Defines a script that runs when the EC2 instance starts
}