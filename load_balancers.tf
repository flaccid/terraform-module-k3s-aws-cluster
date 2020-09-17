resource "random_pet" "lb" {}

resource "aws_lb" "k3s-server" {
  count              = local.create_nlb
  name               = join("-", [local.resource_prefix, "servers", random_pet.lb.id])
  internal           = local.server_nlb_internal
  load_balancer_type = "network"
  subnets            = local.private_subnet_ids
}

resource "aws_lb_listener" "server-port_6443" {
  count             = local.create_nlb
  load_balancer_arn = aws_lb.k3s-server.arn
  port              = "6443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server-6443.arn
  }
}

resource "aws_lb_target_group" "server-6443" {
  count    = local.create_nlb
  name     = join("-", [local.name, "6443", random_pet.lb.id])
  port     = 6443
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_lb" "k3s-agent" {
  count              = local.create_nlb
  name               = join("-", [local.resource_prefix, "agents", random_pet.lb.id])
  internal           = local.agent_nlb_internal
  load_balancer_type = "network"
  subnets            = local.public_subnet_ids

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
  }
}

resource "aws_lb_listener" "port_443" {
  count             = local.create_nlb
  load_balancer_arn = aws_lb.k3s-agent.0.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agent-443.0.arn
  }
}

resource "aws_lb_listener" "port_80" {
  count             = local.create_nlb
  load_balancer_arn = aws_lb.k3s-agent.0.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agent-80.0.arn
  }
}

resource "aws_lb_target_group" "agent-443" {
  count    = local.create_nlb
  name     = substr("${local.name}-443-${random_pet.lb.id}", 0, 24)
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

resource "aws_lb_target_group" "agent-80" {
  count    = local.create_nlb
  name     = substr("${local.name}-80-${random_pet.lb.id}", 0, 24)
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
