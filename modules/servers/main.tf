resource "aws_instance" "servers" {
  count                       = length(var.ami_ids)
  ami                         = element(var.ami_ids[*], count.index)
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnet_ids[*], count.index)
  associate_public_ip_address = true
  vpc_security_group_ids      = var.security_groups_ids
  key_name                    = "project-smart-home"
  
  tags = {
    Name = "${element(var.server_names[*], count.index)}"
  }
}


  
