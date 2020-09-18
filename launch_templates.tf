resource "aws_launch_template" "k3s_master" {
  name_prefix   = "${local.name}-master"
  image_id      = local.master_ami_id
  instance_type = local.master_instance_type
  user_data     = data.template_cloudinit_config.k3s_master.rendered

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = true
      volume_type = "gp2"
      volume_size = "50"
    }
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = concat([aws_security_group.self.id, aws_security_group.egress.id, aws_security_group.database.id], var.extra_master_security_groups)
  }

  tags = {
    Name = "${local.name}-master"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.name}-master"
    }
  }
}

resource "aws_launch_template" "k3s_worker" {
  name_prefix   = "${local.name}-worker"
  image_id      = local.worker_ami_id
  instance_type = local.worker_instance_type
  user_data     = data.template_cloudinit_config.k3s_worker.rendered

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = true
      volume_type = "gp2"
      volume_size = "50"
    }
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = concat([aws_security_group.ingress.id, aws_security_group.egress.id, aws_security_group.self.id], var.extra_worker_security_groups)
  }

  tags = {
    Name = "${local.name}-worker"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.name}-worker"
    }
  }
}
