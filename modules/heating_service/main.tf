resource "aws_instance" "heating_server" {
  count                       = 1
  instance_type               = var.instance_type
  ami                         = "ami-0505148b3591e4c07"
  subnet_id                   = element(var.public_subnet_ids, count.index)
  associate_public_ip_address = true
  vpc_security_group_ids      = var.security_groups_ids
  key_name                    = "project-smart-home"

  tags = {
    Name = "heating"
  }
}
