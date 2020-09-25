resource "aws_security_group" "self" {
  name   = "${local.resource_prefix}-${local.name}-self"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "ingress" {
  name   = "${local.resource_prefix}-${local.name}-ingress"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "egress" {
  name   = "${local.resource_prefix}-${local.name}-egress"
  vpc_id = data.aws_vpc.default.id
}

# TODO: would not be needed it local sqlite default
resource "aws_security_group" "database" {
  name = "${local.resource_prefix}-${local.name}-database"
  # TODO: is this only with default vpc??
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.egress.id
}

resource "aws_security_group_rule" "ingress_all" {
  count             = local.ingress_all
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ingress.id
}

resource "aws_security_group_rule" "self_k3s_master" {
  type      = "ingress"
  from_port = 6443
  to_port   = 6443
  protocol  = "TCP"
  #cidr_blocks       = local.private_subnets_cidr_blocks
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "TCP"
  cidr_blocks       = local.private_subnets_cidr_blocks
  security_group_id = aws_security_group.self.id
}
