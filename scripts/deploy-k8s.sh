#!/usr/bin/env bash
set -euo pipefail

kubectl apply -k k8s/overlays/dev
kubectl -n devops-stack rollout status deployment/startup-api
