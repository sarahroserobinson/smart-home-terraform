resource "aws_launch_template" "launch_template" {
  count         = length(var.service_names)
  name          = "launch-template-${var.service_names[count.index]}"
  image_id      = var.ami_ids[count.index]
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = var.security_groups_ids

   network_interfaces {
    associate_public_ip_address = true
    device_index = 0
  }
  
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "launch-template-${var.service_names[count.index]}"
    }
  }
}

resource "aws_autoscaling_group" "load_balancer_autoscaling_group" {
  count               = length(var.service_names)
  name                = "load-balancer-${var.service_names[count.index]}-autoscaling_group"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = [element(var.public_subnet_ids, count.index)]

  launch_template {
    id = aws_launch_template.launch_template[count.index].id
  }

  target_group_arns = [element(var.load_balancer_target_group_arns, count.index)]

  tag {
    key                 = "Name"
    value               = "${var.service_names[count.index]}-instance-autoscaling-group"
    propagate_at_launch = true
  }
}


