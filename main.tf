locals {
  worker_ami_id               = var.worker_ami_id != null ? var.worker_ami_id : data.aws_ami.ubuntu.id
  worker_instance_type        = var.worker_instance_type
  worker_k3s_exec             = ""
  worker_nlb_internal         = var.worker_nlb_internal
  worker_node_count           = var.worker_node_count
  aws_azs                     = var.aws_azs
  database_name               = var.database_name
  database_node_count         = var.k3s_storage_endpoint != "sqlite" ? var.database_node_count : 0
  db_instance_type            = var.db_instance_type
  deploy_rds                  = var.k3s_storage_endpoint != "sqlite" ? 1 : 0
  install_k3s_version         = var.install_k3s_version
  ingress_all                 = "${var.ingress_all ? 1 : 0}"

  k3s_token                   = var.k3s_token != null ? var.k3s_token : random_password.k3s_token.result
  k3s_disable_worker          = var.k3s_disable_worker ? "--disable-worker" : " "
  k3s_storage_cafile          = var.k3s_storage_cafile
  k3s_storage_endpoint        = var.k3s_storage_endpoint == "sqlite" ? var.k3s_storage_endpoint : "postgres://${local.rds_master_username}:${local.rds_master_password}@${aws_rds_cluster.k3s[0].endpoint}/${local.database_name}"
  k3s_tls_san                 = var.k3s_tls_san != null ? var.k3s_tls_san : "--tls-san ${aws_lb.k3s-master.dns_name}"

  # TODO: how to prevent using " " ?
  name                        = var.name
  output_kubeconfig           = var.output_kubeconfig
  private_subnets_cidr_blocks = var.private_subnets_cidr_blocks
  private_subnet_ids          = length(var.private_subnet_ids) > 0 ? var.private_subnet_ids : data.aws_subnet_ids.available.ids
  public_subnets_cidr_blocks  = var.public_subnets_cidr_blocks
  public_subnet_ids           = length(var.public_subnet_ids) > 0 ? var.public_subnet_ids : data.aws_subnet_ids.available.ids
  rds_private_subnet_ids      = length(var.rds_private_subnet_ids) > 0 ? var.rds_private_subnet_ids : local.private_subnet_ids
  rds_master_username         = length(var.rds_master_username) > 0 ? var.rds_master_username : var.name
  rds_master_password         = length(var.rds_master_password) > 0 ? var.rds_master_password : random_password.rds_master_password.result
  resource_prefix             = var.resource_prefix
  master_ami_id               = var.master_ami_id != null ? var.master_ami_id : data.aws_ami.ubuntu.id
  master_k3s_exec             = ""
  master_instance_type        = var.master_instance_type
  master_nlb_internal         = var.master_nlb_internal
  master_node_count           = var.master_node_count
  skip_final_snapshot         = var.skip_final_snapshot
  ssh_keys                    = var.ssh_keys
  use_rds                     = var.use_rds ? 1 : 0
}


