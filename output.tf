output "Server_public_ip" {
    value = aws_instance.terraform_apache-server.public_ip
}
output "Server_private_ip" {
    value = aws_instance.terraform_apache-server.private_ip
}
output "Server_public_DNS" {
    value = aws_instance.terraform_apache-server.public_dns
}
