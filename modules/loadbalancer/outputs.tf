output "load_balancer_target_group_arns" {
  value = aws_lb_target_group.target_group[*].arn
}
