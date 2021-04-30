resource "aws_security_group" "allow_http_for_elb" {
  name        = "allow_http_for_elb"
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

resource "aws_lb" "dev_elb" {
  name               = "dev-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http_for_elb.id]
  subnets            = [aws_subnet.public1.id,aws_subnet.public2.id]

  tags = {
     Name = "dev-elb"
  }

  depends_on = [aws_instance.ubuntu,aws_s3_bucket.elb_log_bucket]

  access_logs {
    bucket  = var.bucket_name
    enabled = true
  }
}

resource "aws_lb_target_group" "dev_tg" {
  name     = "dev-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.dev.id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "dev" {
  target_group_arn = aws_lb_target_group.dev_tg.arn
  target_id        = aws_instance.ubuntu.id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.dev_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_tg.arn
  }
}