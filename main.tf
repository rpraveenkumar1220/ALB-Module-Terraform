## creating security group for LoadBalancer module ###
resource "aws_security_group" "SG" {
  name        = "${var.name}-alb-${var.env}-sg"
  description = "${var.name}-alb-${var.env}-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.sg_subnet_cidr
  }
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.sg_subnet_cidr
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.allow_ssh_cidr
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-alb-${var.env}-sg"
  }
}

#### Creating Application Load Balancer for APP Components ####
resource "aws_lb" "alb" {
  name               = "${var.name}-alb"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.SG.id]
  subnets            = var.subnets

  tags = {
    Environment = "${var.name}-${var.env}"
    Monitor  = true
  }
}

#### Creating Listener for the Load Balancer #####
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:751367052640:certificate/445550f3-da39-45ef-a415-6085a03d6555"


  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Default Error"
      status_code  = "500"
    }
  }
}


### Creating another Listener to redirect HTTP traffic to HTTPS
resource "aws_lb_listener" "http_traffic" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
