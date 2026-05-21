#!/usr/bin/env bash
set -euo pipefail

command -v docker >/dev/null || { echo "docker is required"; exit 1; }
command -v terraform >/dev/null || { echo "terraform is required"; exit 1; }
command -v kubectl >/dev/null || { echo "kubectl is required"; exit 1; }

echo "Tooling looks good."
