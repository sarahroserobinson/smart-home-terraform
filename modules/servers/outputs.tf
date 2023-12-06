output "server_instance_ids" {
    value = aws_instance.servers[*].id
}