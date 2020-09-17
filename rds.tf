resource "aws_db_subnet_group" "private" {
  count       = local.deploy_rds
  name_prefix = "${local.name}-private"
  subnet_ids  = local.private_subnet_ids
}

resource "aws_rds_cluster_parameter_group" "k3s" {
  count       = local.deploy_rds
  name_prefix = "${local.name}-"
  description = "Force SSL for aurora-postgresql10.7"
  family      = "aurora-postgresql10"

  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "pending-reboot"
  }
}

resource "aws_rds_cluster" "k3s" {
  count                           = local.use_rds
  cluster_identifier_prefix       = "${local.name}-"
  engine                          = "aurora-postgresql"
  engine_mode                     = "provisioned"
  engine_version                  = "10.7"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.k3s.0.name
  availability_zones              = local.aws_azs
  database_name                   = local.database_name
  master_username                 = local.rds_master_username
  master_password                 = local.rds_master_password
  preferred_maintenance_window    = "fri:11:21-fri:11:51"
  db_subnet_group_name            = aws_db_subnet_group.private.0.id
  vpc_security_group_ids          = [aws_security_group.database.id]
  storage_encrypted               = true

  preferred_backup_window   = "11:52-19:52"
  backup_retention_period   = 30
  copy_tags_to_snapshot     = true
  deletion_protection       = false
  skip_final_snapshot       = local.skip_final_snapshot
  final_snapshot_identifier = local.skip_final_snapshot ? null : "${local.name}-final-snapshot"
}

resource "aws_rds_cluster_instance" "k3s" {
  count                = local.database_node_count
  identifier_prefix    = "${local.name}-${count.index}"
  cluster_identifier   = aws_rds_cluster.k3s.0.id
  engine               = "aurora-postgresql"
  instance_class       = local.db_instance_type
  db_subnet_group_name = aws_db_subnet_group.private.0.id
}
