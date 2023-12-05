output "dns_name" {
  value = aws_instance.heating_server[0].public_dns
  description = "Public DNS name for heating instance"
}