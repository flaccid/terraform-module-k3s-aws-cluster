resource "aws_lb" "k3s-master" {
  name               = join("-", [local.resource_prefix, "masters"])
  internal           = local.master_nlb_internal
  load_balancer_type = "network"
  subnets            = local.master_nlb_internal ? local.private_subnet_ids : local.public_subnet_ids
}

resource "aws_lb_target_group" "master-6443" {
  name     = join("-", [local.name, "6443"])
  port     = 6443
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_lb_listener" "master-port_6443" {
  load_balancer_arn = aws_lb.k3s-master.arn
  port              = "6443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.master-6443.arn
  }
}


resource "aws_lb" "k3s-worker" {
  name               = join("-", [local.resource_prefix, "workers"])
  internal           = local.worker_nlb_internal
  load_balancer_type = "network"
  subnets            = local.worker_nlb_internal ? local.private_subnet_ids : local.public_subnet_ids

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
  }
}

resource "aws_lb_listener" "port_443" {
  load_balancer_arn = aws_lb.k3s-worker.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.worker-443.arn
  }
}

resource "aws_lb_listener" "port_80" {
  load_balancer_arn = aws_lb.k3s-worker.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.worker-80.arn
  }
}

resource "aws_lb_target_group" "worker-443" {
  name     = substr("${local.name}-443", 0, 24)
  port     = 443
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    interval            = 10
    timeout             = 6
    path                = "/healthz"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
  }
}

resource "aws_lb_target_group" "worker-80" {
  name     = substr("${local.name}-80", 0, 24)
  port     = 80
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    interval            = 10
    timeout             = 6
    path                = "/healthz"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
  }
}
