resource "aws_autoscaling_group" "k3s_server" {
  count               = local.create_nlb
  name_prefix         = "${local.name}-server"
  desired_capacity    = local.server_node_count
  max_size            = local.server_node_count
  min_size            = local.server_node_count
  vpc_zone_identifier = local.private_subnet_ids

  # only to the secure apiserver
  target_group_arns = [
    aws_lb_target_group.server-6443[count.index].arn
  ]

  launch_template {
    id      = aws_launch_template.k3s_server.id
    version = "$Latest"
  }

  depends_on = [aws_rds_cluster_instance.k3s]
}

resource "aws_autoscaling_group" "k3s_agent" {
  name_prefix         = "${local.name}-agent"
  desired_capacity    = local.agent_node_count
  max_size            = local.agent_node_count
  min_size            = local.agent_node_count
  vpc_zone_identifier = local.private_subnet_ids

  target_group_arns = [
    aws_lb_target_group.agent-80.0.arn,
    aws_lb_target_group.agent-443.0.arn
  ]

  launch_template {
    id      = aws_launch_template.k3s_agent.id
    version = "$Latest"
  }
}
