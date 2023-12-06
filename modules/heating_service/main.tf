resource "aws_instance" "heating_server" {
  count                       = 1
  instance_type               = var.instance_type
  ami                         = var.ami_id_heating_server
  subnet_id                   = element(var.public_subnet_ids, count.index)
  associate_public_ip_address = true
  vpc_security_group_ids      = var.security_groups_ids
  key_name                    = "project-smart-home"

  tags = {
    Name = "heating"
  }
}
