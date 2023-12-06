resource "aws_lb_target_group" "target_group_servers" {
  name             = "target-group-main"
  port             = 3000
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id
  health_check {
    path     = "/health-check"
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "target_group_servers_attachment" {
  count            = length(var.server_instance_ids)
  target_group_arn = aws_lb_target_group.target_group_servers_attachment.arn
  target_id        = element(var.server_instance_ids[*], count.index)
  port             = 3000
}

resource "aws_lb" "lb_main" {
  name                       = "lb_main"
  load_balancer_type         = "application"
  internal                   = false
  security_groups            = var.security_groups_ids
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = true
}


