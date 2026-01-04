#!/bin/bash

# Exit on error
set -e

echo "📦 Installing K3s..."

curl -sfL https://get.k3s.io | sh -

echo "✅ K3s installed"

# Optional: Set KUBECONFIG
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Make sure kubectl works
echo "🔍 Checking kubectl..."
kubectl get nodes
