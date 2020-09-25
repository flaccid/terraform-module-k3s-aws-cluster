#!/bin/bash
#set -e

export INSTALL_K3S_VERSION='v${install_k3s_version}'
export K3S_TOKEN='${k3s_token}'

%{ if is_k3s_master }
  %{ if k3s_storage_endpoint != "sqlite" }
curl -o ${k3s_storage_cafile} https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem
  %{ endif }

echo "[INFO]: installing master"
until (curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION='v${install_k3s_version}' INSTALL_K3S_EXEC='${k3s_tls_san} ${k3s_disable_worker} ${k3s_exec}' K3S_TOKEN='${k3s_token}' %{ if k3s_storage_endpoint != "sqlite" }K3S_STORAGE_CAFILE='${k3s_storage_cafile}' K3S_STORAGE_ENDPOINT='${k3s_storage_endpoint}'%{ endif } sh -); do
  echo '[WARN]: k3s did not install correctly'
  sleep 2
done
until kubectl get pods -A | grep 'Running';
do
  echo 'Waiting for k3s startup'
  sleep 5
done
%{ else }
echo "[INFO]: installing worker"
until (curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION='v${install_k3s_version}' INSTALL_K3S_EXEC='${k3s_exec}' K3S_TOKEN='${k3s_token}' K3S_URL='https://${k3s_url}:6443' sh -); do
  echo '[WARN]: k3s did not install correctly'
  sleep 2
done
%{ endif }
