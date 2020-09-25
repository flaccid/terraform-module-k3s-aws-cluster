resource "random_password" "k3s_token" {
  length  = 30
  special = false
}
resource "random_password" "rds_master_password" {
  length  = 30
  special = false
}
