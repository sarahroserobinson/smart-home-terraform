
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "allows ingress and egress traffic for HTTP requests from all external sources"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = local.ipv4_all_cidr_blocks
  ipv6_cidr_blocks  = local.ipv6_all_cidr_blocks
  security_group_id = aws_security_group.allow_http.id
}

resource "aws_security_group_rule" "allow_egress_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = local.ipv4_all_cidr_blocks
  ipv6_cidr_blocks  = local.ipv6_all_cidr_blocks
  security_group_id = aws_security_group.allow_http.id
}

resource "aws_security_group" "allow_https" {
  name        = "allow_https"
  description = "allows ingress and egress traffic for HTTPS requests from all external sources"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = local.ipv4_all_cidr_blocks
  ipv6_cidr_blocks  = local.ipv6_all_cidr_blocks
  security_group_id = aws_security_group.allow_https.id
}

resource "aws_security_group_rule" "allow_egress_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = local.ipv4_all_cidr_blocks
  ipv6_cidr_blocks  = local.ipv6_all_cidr_blocks
  security_group_id = aws_security_group.allow_https.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "allows ingress ssh from own IP address"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myipv4address.response_body)}/32"]
  ipv6_cidr_blocks  = ["${chomp(data.http.myipv6address.response_body)}/128"]
  security_group_id = aws_security_group.allow_ssh.id
}
