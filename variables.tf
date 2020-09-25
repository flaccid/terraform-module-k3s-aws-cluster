variable "name" {
  type        = string
  default     = "aws-k3s-demo"
  description = "Name for deployment"
}

variable "resource_prefix" {
  default     = "k3s"
  type        = string
  description = "The prefix to use for AWS resources"
}

variable "worker_ami_id" {
  type        = string
  default     = null
  description = "AMI to use for k3s worker instances"
}

variable "master_ami_id" {
  type        = string
  default     = null
  description = "AMI to use for k3s master instances"
}

variable "r53_zone_id" {
  type        = string
  default     = ""
  description = "Route 53 Zone ID"
}

variable "master_instance_type" {
  type    = string
  default = "m5.large"
}

variable "worker_instance_type" {
  type    = string
  default = "m5.large"
}

variable "master_nlb_internal" {
  type    = bool
  default = true
}

variable "worker_nlb_internal" {
  type    = bool
  default = true
}

variable "master_node_count" {
  type        = number
  default     = 1
  description = "Number of master nodes to launch"
}

variable "worker_node_count" {
  type        = number
  default     = 1
  description = "Number of worker nodes to launch"
}

variable "database_node_count" {
  type        = number
  default     = 1
  description = "Number of RDS database instances to launch"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "The vpc id that Rancher should use"
}

variable "public_subnet_ids" {
  default     = []
  type        = list
  description = "List of public subnet ids."
}

variable "private_subnet_ids" {
  default     = []
  type        = list
  description = "List of private subnet ids."
}

variable "install_k3s_version" {
  default     = "1.18.9+k3s1"
  type        = string
  description = "Version of K3S to install, matching the release tag"
}

variable "extra_master_security_groups" {
  default     = []
  type        = list
  description = "Additional security groups to attach to k3s master instances"
}

variable "extra_worker_security_groups" {
  default     = []
  type        = list
  description = "Additional security groups to attach to k3s worker instances"
}

variable "aws_azs" {
  default     = null
  type        = list
  description = "List of AWS Availability Zones in the VPC"
}

variable "db_instance_type" {
  default = "db.r5.large"
}

variable "database_name" {
  default     = "aws-k3s-demo"
  type        = string
  description = "Name of database to create for k3s"
}

variable "rds_private_subnet_ids" {
  type        = list
  description = "RDS Private Subnet ids"
  default     = []
}
variable "rds_master_username" {
  type        = string
  description = "Master username for RDS database"
  default     = ""
}

variable "rds_master_password" {
  type        = string
  description = "Master password for RDS user"
  default     = ""
}

variable "private_subnets_cidr_blocks" {
  default     = []
  type        = list
  description = "List of cidr_blocks of private subnets"
}

variable "public_subnets_cidr_blocks" {
  default     = []
  type        = list
  description = "List of cidr_blocks of public subnets"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Boolean that defines whether or not the final snapshot should be created on RDS cluster deletion"
  default     = true
}

variable "k3s_storage_endpoint" {
  default     = "sqlite"
  type        = string
  description = "Storage Backend for K3S cluster to use. Valid options are 'sqlite' or 'postgres'"
}

variable "k3s_disable_worker" {
  default     = false
  type        = bool
  description = "Whether to run the k3s worker on the same host as the k3s master"
}

variable "ssh_keys" {
  type        = list
  default     = []
  description = "SSH keys to inject into Rancher instances"
}

variable "use_rds" {
  default     = false
  type        = bool
  description = "Whether to use RDS or not"
}

variable "k3s_token" {
  default     = null
  type        = string
  description = "Override to set k3s cluster registration secret"
}

variable "k3s_storage_cafile" {
  # TODO: is this really the right place?
  default     = "/srv/rds-combined-ca-bundle.pem"
  type        = string
  description = "Location to download RDS CA Bundle"
}

variable "k3s_tls_san" {
  default     = null
  type        = string
  description = "Sets k3s tls-san flag to this value instead of the default load balancer"
}

variable "output_kubeconfig" {
  default     = false
  type        = bool
  description = "Whether to provide the kubeconfig as a terraform output"
}

variable "ingress_all" {
  default     = false
  type        = bool
  description = "Whether to open all IPs to the ingress security group"
}
