# ubuntu - ami-03b7a7ce915b46b75
# nginx - ami-0f573809c9062bff2
resource "aws_instance" "web" {
  ami                         = "ami-0f573809c9062bff2"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  tags                        = merge(local.common_tags, { Name = "basic-infra-instance-web" })
  vpc_security_group_ids      = [aws_security_group.public_http_traffic.id]
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "public_http_traffic" {
  description = "Security group for public HTTP traffic"
  name        = "public-http-traffic"
  vpc_id      = aws_vpc.main.id
  tags        = merge(local.common_tags, { Name = "basic-infra-sg-public-http-traffic" })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}