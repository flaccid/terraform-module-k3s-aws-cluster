locals {
  worker_ami_id        = var.worker_ami_id != null ? var.worker_ami_id : data.aws_ami.ubuntu.id
  worker_instance_type = var.worker_instance_type
  worker_k3s_exec      = ""
  worker_nlb_internal  = var.worker_nlb_internal
  worker_node_count    = var.worker_node_count
  aws_azs             = var.aws_azs
  database_name       = var.database_name
  database_node_count = var.k3s_storage_endpoint != "sqlite" ? var.database_node_count : 0
  db_instance_type    = var.db_instance_type
  deploy_rds          = var.k3s_storage_endpoint != "sqlite" ? 1 : 0
  install_k3s_version = var.install_k3s_version
  k3s_cluster_secret  = var.k3s_cluster_secret != null ? var.k3s_cluster_secret : random_password.k3s_cluster_secret.result
  k3s_disable_worker   = var.k3s_disable_worker ? "--disable-worker" : " "
  k3s_storage_cafile  = var.k3s_storage_cafile
  # TODO: how to prevent using " " ?
  k3s_storage_endpoint        = var.k3s_storage_endpoint == "sqlite" ? " " : "postgres://${local.rds_master_username}:${local.rds_master_password}@something/${local.database_name}"
  k3s_tls_san                 = var.k3s_tls_san != null ? var.k3s_tls_san : "--tls-san fixme"
  name                        = var.name
  output_kubeconfig           = var.output_kubeconfig
  private_subnets_cidr_blocks = var.private_subnets_cidr_blocks
  private_subnet_ids          = length(var.private_subnet_ids) > 0 ? var.private_subnet_ids : data.aws_subnet_ids.available.ids
  rds_private_subnet_ids      = slice(local.private_subnet_ids, 1, 4) # This is because rds can *only* handle up to 3 subnets, whereas private_subnets may be more than that
  public_subnets_cidr_blocks  = var.public_subnets_cidr_blocks
  public_subnet_ids           = length(var.public_subnet_ids) > 0 ? var.public_subnet_ids : data.aws_subnet_ids.available.ids
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
