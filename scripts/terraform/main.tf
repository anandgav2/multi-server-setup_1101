provider "aws" {
  region = var.region  # Update this to your desired AWS region
}

locals {
  host_data = file(var.host_alias_path)
}

resource "tls_private_key" "new_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "aws-cip-key-multi" {
  key_name   = "aws-key-multi-cip"
  public_key = tls_private_key.new_key.public_key_openssh
}


resource "aws_instance" "cip" {
  ami           = var.ami  # Replace with your desired AMI ID
  instance_type = var.instance_type    # Replace with your desired instance type
  key_name      = aws_key_pair.aws-cip-key-multi.key_name  # Replace with your SSH key pair name
  count         = length([for line in split("\n", local.host_data) : line if length(line) > 0])

  tags = {
    Name = "multi-server-instance-${count.index + 1}"
    hostname = "${element(split(" ",element(split("\n",local.host_data),count.index)),1)}"
    alias = "${element(split(" ",element(split("\n",local.host_data),count.index)),0)}"
  }

  user_data = <<-EOF
    #!/bin/bash
    setenforce 0
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sudo systemctl restart sshd
    hostnamectl set-hostname "${element(split(" ",element(split("\n",local.host_data),count.index)),1)}"
  EOF

  vpc_security_group_ids = [aws_security_group.cip-multi.id]  # Attach the security group here

  root_block_device {
    volume_size = 30
  }

}

output "cip_instance_public_ip" {
  value = [for instance in aws_instance.cip : instance.public_ip]
}


output "private_key_pem" {
  value = tls_private_key.new_key.private_key_pem
  sensitive = true
}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
}

# Call local-exec provisioner after the instance is created
resource "null_resource" "generate_host_alias" {
  
  triggers = {
    cip_instance_public_ip = join(",",[for instance in aws_instance.cip : instance.public_ip])
  }

  provisioner "local-exec" {
    command = <<-EOT
      /usr/bin/ssh-keyscan -v -t rsa ${join(" ", aws_instance.cip[*].public_ip)} >> ~/.ssh/known_hosts
      echo '${join("\n", [for instance in aws_instance.cip : "${instance.tags.alias} ${instance.public_ip} ${instance.tags.hostname}" ])}' > ${var.host_alias_path}
      chmod 666 ${var.host_alias_path}
    EOT
  }

  depends_on = [ time_sleep.wait_60_seconds ]
  
}

resource "local_file" "aws-cip-key-multi" {
  content = tls_private_key.new_key.private_key_pem
  filename = "aws-cip-key-multi.pem"
  file_permission = "0400"
}
