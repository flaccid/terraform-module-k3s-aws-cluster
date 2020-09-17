module "files" {
  source  = "matti/resource/shell"
  command = "ls -l"
}

output "my_files" {
  value = module.files.stdout
}

# TODO: complete

# output "k3s_kube_config" {
#   value = local.k3s_kubeconfig
# }
