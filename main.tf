# Replace with your actual VPC ID and Subnet IDs
variable "vpc_id" {
  default = "vpc-09379eb48c89ff3d6"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-092effb46de01d4da", "subnet-0e9c0ce018870ed76"]
}

resource "aws_security_group" "elb_sg" {
  name        = "elb-sg"
  description = "Allow HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "my_elb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "java_tg" {
  name        = "java-tg"
  port        = 9000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    port                = "9000"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.my_elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.java_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_lb_target_group.java_tg.arn
  target_id        = "i-0bec6df03932555e8"  # <- Replace with your EC2 instance ID
  port             = 9000
}
