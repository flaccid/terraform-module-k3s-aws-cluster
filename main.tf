locals {
  agent_ami_id        = var.agent_ami_id != null ? var.agent_ami_id : data.aws_ami.ubuntu.id
  agent_instance_type = var.agent_instance_type
  agent_k3s_exec      = ""
  agent_nlb_internal  = var.agent_nlb_internal
  agent_node_count    = var.agent_node_count
  aws_azs             = var.aws_azs
  create_nlb          = var.create_nlb ? 1 : 0
  database_name       = var.database_name
  database_node_count = var.k3s_storage_endpoint != "sqlite" ? var.database_node_count : 0
  db_instance_type    = var.db_instance_type
  deploy_rds          = var.k3s_storage_endpoint != "sqlite" ? 1 : 0
  install_k3s_version = var.install_k3s_version
  k3s_cluster_secret  = var.k3s_cluster_secret != null ? var.k3s_cluster_secret : random_password.k3s_cluster_secret.result
  k3s_disable_agent   = var.k3s_disable_agent ? "--disable-agent" : " "
  k3s_storage_cafile  = var.k3s_storage_cafile
  # TODO: how to prevent using " " ?
  k3s_storage_endpoint        = var.k3s_storage_endpoint == "sqlite" ? " " : "postgres://${local.rds_master_username}:${local.rds_master_password}@${aws_rds_cluster.k3s.0.endpoint}/${local.database_name}"
  k3s_tls_san                 = var.k3s_tls_san != null ? var.k3s_tls_san : "--tls-san ${aws_lb.k3s-server.dns_name}"
  name                        = var.name
  output_kubeconfig           = var.output_kubeconfig
  private_subnets_cidr_blocks = var.private_subnets_cidr_blocks
  private_subnet_ids          = length(var.private_subnet_ids) > 0 ? var.private_subnet_ids : data.aws_subnet_ids.available.ids
  public_subnets_cidr_blocks  = var.public_subnets_cidr_blocks
  public_subnet_ids           = length(var.public_subnet_ids) > 0 ? var.public_subnet_ids : data.aws_subnet_ids.available.ids
  rds_master_username         = var.rds_master_username
  rds_master_password         = var.rds_master_password
  resource_prefix             = var.resource_prefix
  server_ami_id               = var.server_ami_id != null ? var.server_ami_id : data.aws_ami.ubuntu.id
  server_k3s_exec             = ""
  server_instance_type        = var.server_instance_type
  server_nlb_internal         = var.server_nlb_internal
  server_node_count           = var.server_node_count
  skip_final_snapshot         = var.skip_final_snapshot
  ssh_keys                    = var.ssh_keys
  use_rds                     = var.use_rds ? 1 : 0
}
