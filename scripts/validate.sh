#!/usr/bin/env bash
set -euo pipefail

terraform -chdir=terraform fmt -recursive -check
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
kubectl kustomize k8s/overlays/dev >/tmp/devops-stack-rendered.yaml
kubectl apply --dry-run=client -f /tmp/devops-stack-rendered.yaml

echo "Validation completed successfully."
