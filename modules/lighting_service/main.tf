resource "aws_instance" "lighting_server" {
  count                       = 1
  ami                         = var.ami_id_lighting_server
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnet_ids, count.index)
  associate_public_ip_address = true
  vpc_security_group_ids      = var.security_groups_ids
  key_name                    = "project-smart-home"
  
  tags = {
    Name = "lighting"
  }
}


  