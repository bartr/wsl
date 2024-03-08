#!/bin/bash

cd "$HOME/wsl"

# validate config file
if [ ! -f k3d.yaml ]; then
	echo "File not found - k3d.yaml"
	exit 1
fi

k3d cluster delete

set -e

echo ""
echo "Creating cluster ..."

k3d cluster create \
    --k3s-arg '--no-deploy=traefik@server:0' \
    --config k3d.yaml

echo "waiting for cluster to start"
sleep 10
kubectl wait pods -n kube-system -l k8s-app=kube-dns --for condition=Ready --timeout=30s

echo ""
echo "waiting for cluster metric-server to start"
kubectl wait pods -n kube-system -l k8s-app=metrics-server --for condition=Ready --timeout=30s

echo ""
kubectl get pods -A
