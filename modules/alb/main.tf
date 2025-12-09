resource "aws_lb" "alb" {
  name               = "demo-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids

  tags = var.tags
}

resource "aws_lb_target_group" "tg" {
  name     = "demo-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group_attachment" "attach" {
  for_each = toset(var.instance_ids)

  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = each.value
  port             = 80
}

data "aws_vpc" "vpc" {
  id = split("/", var.subnet_ids[0])[1]
}
