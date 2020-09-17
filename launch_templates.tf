resource "aws_launch_template" "k3s_server" {
  name_prefix   = "${local.name}-server"
  image_id      = local.server_ami_id
  instance_type = local.server_instance_type
  user_data     = data.template_cloudinit_config.k3s_server.rendered

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
    security_groups       = concat([aws_security_group.self.id, aws_security_group.egress.id, aws_security_group.database.id], var.extra_server_security_groups)
  }

  tags = {
    Name = "${local.name}-server"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.name}-server"
    }
  }
}

resource "aws_launch_template" "k3s_agent" {
  name_prefix   = "${local.name}-agent"
  image_id      = local.agent_ami_id
  instance_type = local.agent_instance_type
  user_data     = data.template_cloudinit_config.k3s_agent.rendered

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
    security_groups       = concat([aws_security_group.ingress.id, aws_security_group.egress.id, aws_security_group.self.id], var.extra_agent_security_groups)
  }

  tags = {
    Name = "${local.name}-agent"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.name}-agent"
    }
  }
}
