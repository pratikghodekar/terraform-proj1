data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_network_interface" "ubuntu_nic" {
  subnet_id   = aws_subnet.private.id
  security_groups = [aws_security_group.allow_http.id]

  tags = {
    Name = "ubuntu_nic"
  }
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.aws_keypair

  network_interface {
    network_interface_id = aws_network_interface.ubuntu_nic.id
    device_index         = 0
  }

  user_data = <<-EOF
		            #! /bin/bash
                sudo apt-get update
                sudo apt-get install -y apache2
                sudo systemctl start apache2
                sudo systemctl enable apache2
                echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "ubuntu"
  }
}