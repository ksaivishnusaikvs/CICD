resource "aws_instance" "k3s_node" {
  ami           = "ami-0c2b8ca1dad447f8a" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  key_name = "your-key-pair"

  tags = {
    Name = "k3s-node"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -sfL https://get.k3s.io | sh -",
      "chmod 644 /etc/rancher/k3s/k3s.yaml"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/your-key.pem")
      host        = self.public_ip
    }
  }
}
