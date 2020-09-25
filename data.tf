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

data "template_cloudinit_config" "k3s_master" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/files/cloud-config-base.yaml", { ssh_keys = var.ssh_keys })
  }

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/files/k3s-install.sh", {
                      install_k3s_version  = local.install_k3s_version,
                      is_k3s_master        = true,
                      k3s_exec             = local.master_k3s_exec,
                      k3s_token            = local.k3s_token,
                      k3s_url              = aws_lb.k3s-master.dns_name,
                      k3s_storage_endpoint = local.k3s_storage_endpoint,
                      k3s_storage_cafile   = local.k3s_storage_cafile,
                      k3s_disable_worker   = local.k3s_disable_worker,
                      k3s_tls_san          = local.k3s_tls_san
                    })
  }
}

data "template_cloudinit_config" "k3s_worker" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/files/cloud-config-base.yaml", { ssh_keys = var.ssh_keys })
  }

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/files/k3s-install.sh", {
                      install_k3s_version  = local.install_k3s_version,
                      is_k3s_master        = false,
                      k3s_exec             = local.worker_k3s_exec,
                      k3s_token            = local.k3s_token,
                      k3s_url              = aws_lb.k3s-master.dns_name,
                      k3s_storage_endpoint = local.k3s_storage_endpoint,
                      k3s_storage_cafile   = local.k3s_storage_cafile,
                      k3s_disable_worker   = local.k3s_disable_worker,
                      k3s_tls_san          = local.k3s_tls_san
                    })
  }
}

## problem: potential race condition
#data "aws_instances" "k3s-master-asg" {
#  instance_tags = {
#    Name = join("-", ["k3s", var.name, "master"])
#  }
#  #depends_on = [aws_autoscaling_group.k3s_master]
#}
