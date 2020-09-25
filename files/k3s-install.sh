#!/bin/bash
#set -e

export INSTALL_K3S_VERSION='v${install_k3s_version}'
export K3S_TOKEN='${k3s_token}'

%{ if is_k3s_master }
  %{ if k3s_storage_endpoint != "sqlite" }
  echo "[INFO]: Fetching https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem to ${k3s_storage_cafile}"
  curl -o ${k3s_storage_cafile} https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem
  export K3S_STORAGE_CAFILE='${k3s_storage_cafile}'
  export K3S_STORAGE_ENDPOINT='${k3s_storage_endpoint}'
  %{ endif }
  export INSTALL_K3S_EXEC='${k3s_tls_san} ${k3s_disable_worker} ${k3s_exec}'
%{ else }
  export INSTALL_K3S_EXEC='${k3s_exec}'
  export K3S_URL='https://${k3s_url}:6443'
%{ endif }

echo "[INFO]: K3S_STORAGE_CAFILE=$${K3S_STORAGE_CAFILE}"
echo "[INFO]: K3S_STORAGE_ENDPOINT=$${K3S_STORAGE_ENDPOINT}"
echo "[INFO]: INSTALL_K3S_EXEC=$${INSTALL_K3S_EXEC}"
echo "[INFO]: K3S_URL=$${K3S_URL}"

until (curl -sfL https://get.k3s.io | sh -); do
  echo '[WARN]: k3s did not install correctly'
  sleep 2
done

%{ if is_k3s_master }
until kubectl get pods -A | grep 'Running';
do
  echo '[WARN]: Waiting for k3s startup'
  sleep 5
done
%{ endif }
