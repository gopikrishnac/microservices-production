#!/usr/bin/env bash

set -euo pipefail

echo "===> 1. Creating 2GB Swapfile (Memory buffer for t3.medium)..."
if [ ! -f /swapfile ]; then
  sudo fallocate -l 2G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
  echo "Swapfile enabled successfully."
else
  echo "Swapfile already exists. Skipping."
fi

echo "===> 2. Installing K3s (Lightweight Kubernetes)..."
curl -sfL https://get.k3s.io | sh -

echo "===> 3. Configuring kubeconfig for standard user..."
mkdir -p "$HOME/.kube"
sudo cp /etc/rancher/k3s/k3s.yaml "$HOME/.kube/config"
sudo chown "$(id -u):$(id -g)" "$HOME/.kube/config"
chmod 600 "$HOME/.kube/config"

# Export KUBECONFIG in .bashrc if not already present
if ! grep -q "KUBECONFIG" "$HOME/.bashrc"; then
  echo "export KUBECONFIG=\$HOME/.kube/config" >> "$HOME/.bashrc"
fi

echo "===> 4. Verifying cluster status..."
kubectl wait --for=condition=Ready nodes --all --timeout=60s
kubectl get nodes -o wide

echo "K3s installation complete!"