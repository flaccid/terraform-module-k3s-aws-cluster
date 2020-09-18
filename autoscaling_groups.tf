resource "aws_autoscaling_group" "k3s_master" {
  name_prefix         = "${local.resource_prefix}-${local.name}-master"
  desired_capacity    = local.master_node_count
  max_size            = local.master_node_count
  min_size            = local.master_node_count
  vpc_zone_identifier = local.master_nlb_internal ? local.private_subnet_ids : local.public_subnet_ids

  # only to the secure apimaster
  target_group_arns = [
    aws_lb_target_group.master-6443.arn
  ]

  launch_template {
    id      = aws_launch_template.k3s_master.id
    version = "$Latest"
  }

  depends_on = [aws_rds_cluster_instance.k3s]
}

resource "aws_autoscaling_group" "k3s_worker" {
  name_prefix         = "${local.resource_prefix}-${local.name}-worker"
  desired_capacity    = local.worker_node_count
  max_size            = local.worker_node_count
  min_size            = local.worker_node_count
  vpc_zone_identifier = local.worker_nlb_internal ? local.private_subnet_ids : local.public_subnet_ids

  target_group_arns = [
    aws_lb_target_group.worker-80.arn,
    aws_lb_target_group.worker-443.arn
  ]

  launch_template {
    id      = aws_launch_template.k3s_worker.id
    version = "$Latest"
  }
}
