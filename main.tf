provider "aws" { 
  region = var.region
}


# Generate SSH key pair
resource "tls_private_key" "example_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save the public key to a local file
resource "local_file" "public_key" {
  filename = "${path.module}/public_key.pem"
  content  = tls_private_key.example_ssh_key.public_key_openssh
}

resource "aws_instance" "example" {
  ami         = var.ami-os 
  instance_type = "t2.micro"              
  key_name      = var.key   

    tags = {
    Name = "example-instance"
  }
  

user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y openjdk-11-jdk
              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
              https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
              https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
              /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get update -y
              sudo apt-get install -y jenkins      
     EOF
}
