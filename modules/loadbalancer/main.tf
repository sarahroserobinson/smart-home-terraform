resource "aws_lb" "lb_main" {
  name               = "lbmain"
  load_balancer_type = "application"
  internal           = false
  security_groups    = var.security_groups_ids
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "target_group" {
  count            = length(var.service_names)
  name             = "target-group-${var.service_names[count.index]}"
  port             = 3000
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id
  health_check {
    path     = "/api/${var.target_group_paths[count.index]}"
    protocol = "HTTP"
  }
  tags = {
    Name = "target-group-${var.service_names[count.index]}"
  }
}

resource "aws_lb_target_group_attachment" "target_group_servers_attachment" {
  count            = length(var.server_instance_ids)
  target_group_arn = aws_lb_target_group.target_group[count.index].arn
  target_id        = var.server_instance_ids[count.index]
  port             = 3000
}


resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb_main.arn
  port              = 3000
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[2].arn
  }
  tags = {
    Name = "target-group-${(var.service_names[2])}"
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  count        = 2
  listener_arn = aws_lb_listener.lb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[count.index].arn
  }

  condition {
    path_pattern {
      values = ["/api/${var.target_group_paths[count.index]}*"]
    }
  }
}

