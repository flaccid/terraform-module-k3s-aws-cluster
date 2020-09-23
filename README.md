# terraform-module-k3s-aws-cluster

Terraform module to spin up a k3s cluster on EC2 with existing or new related AWS resources.

## Operating System Support

Currently defaults to Ubuntu, which should also work with upstream Debian.
Work is needed to be done in the pre-seed scripts to cater for other operating systems.

## Usage

### Inputs

TODO: add in all the inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `database_name` | Name of database to create for k3s | `string` | `aws-k3s-demo` | no |
| `ingress_all` | Whether to open up ingress to all IPs on nodes | `string` | `false` | no |
| `install_k3s_version` |	Version of K3S to install	string | `string` | `"1.18.9+k3s1"` | no |
| `master_nlb_internal` | If the provisioned NLB for masters should be internal | `bool` | `true` | no |
| `resource_prefix` | Name prefix to use for AWS resources | `string` | `k3s` | no |
| `ssh_keys` | SSH public keys to inject into instances | `list` | `[]` | no |
| `worker_nlb_internal` | If the provisioned NLB for workers should be internal | `bool` | `true` | no |

### Outputs

TODO: yet to be completed

| Name | Description |
|------|-------------|
| `k3s_kubeconfig` | The kubeconfig for the k3s cluster |

# License

```
Copyright (c) 2014-2020 [Rancher Labs, Inc.](http://rancher.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
