locals {
  # Prefer explicit map; fall back to list -> map conversion; empty map if neither provided.
  instance_map = (
    var.instance_id_map != null ? var.instance_id_map :
    length(var.instance_ids) > 0 ? { for idx, id in var.instance_ids : tostring(idx) => id } :
    {}
  )
}

# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "demo-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  enable_http2       = true

  tags = merge({ Name = "demo-alb" }, var.tags)
}

# Target Group (must use a VPC id)
resource "aws_lb_target_group" "tg" {
  name     = "demo-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = merge({ Name = "demo-tg" }, var.tags)
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Attach instances to the target group using stable keys
resource "aws_lb_target_group_attachment" "attach" {
  for_each         = local.instance_map
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = each.value
  port             = 80
}
