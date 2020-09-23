#!/bin/sh

# this script will output the kubeconfig from the first master to stdout
# requires: terraform, jq, ssh

: ${SSH_USER:=ubuntu}

tmpfile="$(mktemp /tmp/k3s.XXXXXX)"
terraform show -json | jq > "$tmpfile"
ssh_ip=$(cat "$tmpfile" | jq '.values.root_module.child_modules[0].resources | map(. | select(.address=="module.k3s_cluster.data.aws_instances.k3s-master-asg")) | .[].values.public_ips[0] ' --raw-output)
rm "$tmpfile"

echo "ssh user: $SSH_USER, master ip: $ssh_ip"
echo "attempting ssh command to get kubeconfig.."
ssh "$SSH_USER@$ssh_ip" 'sudo cat /etc/rancher/k3s/k3s.yaml'
