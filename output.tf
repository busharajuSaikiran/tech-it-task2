output "public_ip" {
    description = "this is the public IP"
    value = aws_instance.example.public_ip
}

output "private_ip" {
    description = "this is the public IP"
    value = aws_instance.example.private_ip
}
