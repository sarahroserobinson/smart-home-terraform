output "security_groups_ids" {
  value = [aws_security_group.allow_http.id, aws_security_group.allow_https.id, aws_security_group.allow_ssh.id, aws_security_group.allow_port_3000.id]
}
