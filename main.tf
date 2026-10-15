resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for web server"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  description = "SSH from my IP"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["152.56.3.173/32"]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd

    cat > /var/www/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
      <head>
        <title>Multi-tier Web Application</title>
      </head>
      <body>
        <h1>Multi-tier Web Application</h1>
        <h2>Infrastructure as Code using Terraform</h2>
        <p>Project deployed successfully on AWS!</p>
      </body>
    </html>
    HTML
  EOF

  tags = {
    Name = "${var.project_name}-web-server"
  }
}