data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# SSH key generation & registration

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/${var.builder_key_filename}"
  file_permission = "0600"
}

resource "aws_key_pair" "builder_key" {
  key_name   = "maayan-builder-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
  tags = {
   Name  = "maayan-builder-key"
   Owner = "maayan"
  }
}

# Security Group

resource "aws_security_group" "builder_sg" {
  name        = "maayan-builder-sg"
  description = "Allow SSH and app port 5001"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  ingress {
    description = "Python app port"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    description      = "All outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "builder-sg" }
}

# EC2 instance Ubuntu
resource "aws_instance" "builder" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.builder_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.builder_key.key_name

  tags = { 
    Name = "maayan-builder"
    Owner = "maayan"
  }

}

