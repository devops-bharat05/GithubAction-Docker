provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


# EC2 Instance
resource "aws_instance" "devops_ec2" {
  ami           = "ami-03f4878755434977f" # Ubuntu 22.04 (Mumbai)
  instance_type = "t3.micro"
  key_name      = var.key_name                       

  tags = {
    Name = "DevOps-GitHub-Runner"
  }
}

# Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "devops-ec2-sg"
  description = "Allow SSH, HTTP, HTTPS, and app ports"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App Ports"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-ec2-sg"
  }
}