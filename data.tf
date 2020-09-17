data "aws_vpc" "default" {
  default = false
  id      = var.vpc_id
}

data "aws_subnet_ids" "available" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/*/ubuntu-focal-20.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "template_cloudinit_config" "k3s_server" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/files/cloud-config-base.yaml", { ssh_keys = var.ssh_keys })
  }

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/files/k3s-install.sh", { install_k3s_version = local.install_k3s_version, k3s_exec = local.server_k3s_exec, k3s_cluster_secret = local.k3s_cluster_secret, is_k3s_server = true, k3s_url = aws_lb.k3s-server.dns_name, k3s_storage_endpoint = local.k3s_storage_endpoint, k3s_storage_cafile = local.k3s_storage_cafile, k3s_disable_agent = local.k3s_disable_agent, k3s_tls_san = local.k3s_tls_san })
  }
}

data "template_cloudinit_config" "k3s_agent" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/files/cloud-config-base.yaml", { ssh_keys = var.ssh_keys })
  }

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/files/k3s-install.sh", { install_k3s_version = local.install_k3s_version, k3s_exec = local.agent_k3s_exec, k3s_cluster_secret = local.k3s_cluster_secret, is_k3s_server = false, k3s_url = aws_lb.k3s-server.dns_name, k3s_storage_endpoint = local.k3s_storage_endpoint, k3s_storage_cafile = local.k3s_storage_cafile, k3s_disable_agent = local.k3s_disable_agent, k3s_tls_san = local.k3s_tls_san })
  }
}


# data "external" "k3s_kubeconfig" {
#   program = ["cat /etc/rancher/k3s/k3s.yaml"]
#
#   query = {
#     controller = "${packet_device.controller.network.0.address}"
#   }
# }
