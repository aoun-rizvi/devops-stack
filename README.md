# Startup DevOps Stack

A practical DevOps starter repository for startups moving beyond manual deploys.

This repository demonstrates a production-minded path from local development to cloud deployment using:

- Terraform AWS starter infrastructure
- Docker Compose for local development
- Kubernetes manifests for application deployment
- CI/CD example with GitHub Actions
- Monitoring and observability notes

This project is intentionally simple enough to understand quickly, but structured like a real repository a growing engineering team could extend.

## Why this exists

Early-stage teams often begin with manual SSH deploys, copied environment files, ad-hoc Docker commands, and undocumented infrastructure. That works briefly, but it becomes risky as more developers, services, environments, and customers are added.

This repository shows how to move toward:

- repeatable infrastructure
- containerized local development
- automated build and validation
- declarative Kubernetes deployments
- basic health checks and observability
- safer release practices

## Architecture

```text
Developer
   |
   | git push / pull request
   v
GitHub Actions CI/CD
   |
   |-- Triggered on pull requests and pushes to main
   |
   |-- Creates temporary Ubuntu GitHub Actions runner
   |
   |-- Checks out repository source code
   |
   |-- Installs Node.js dependencies
   |
   |-- Runs application tests
   |
   |-- Builds Docker image tagged with Git commit SHA
   |
   |-- Installs and validates Terraform configuration
   |     |-- terraform fmt check
   |     |-- terraform init (backend disabled)
   |     |-- terraform validate
   |
   |-- Installs kubectl
   |
   |-- Renders Kubernetes manifests using Kustomize
   |
   |-- Performs Kubernetes dry-run validation
   |
   |-- Pipeline passes/fails based on validation results
   |
   |-- Future extension:
         |-- Push Docker images to ECR
         |-- Deploy to Kubernetes cluster
         |-- Add security/vulnerability scanning
         |-- Multi-environment promotion (dev/stage/prod)
   |
   v
Terraform AWS Infrastructure
   │
   └── VPC: 10.20.0.0/16
      │
      ├── Internet Gateway
      │   └── Connects VPC to the public internet
      │
      ├── Public Route Table
      │   └── Route:
      │       0.0.0.0/0 → Internet Gateway
      │
      ├── Availability Zone 1
      │   │
      │   ├── Public Subnet
      │   │   │
      │   │   ├── Load Balancer / Ingress
      │   │   │   └── Receives internet traffic
      │   │   │
      │   │   ├── NAT Gateway (optional)
      │   │   │   └── Gives private subnet outbound internet access
      │   │   │
      │   │   └── Security Group
      │   │       └── Controls inbound/outbound traffic
      │   │
      │   └── Private Subnet
      │       │
      │       ├── Kubernetes Worker Nodes
      │       ├── Application Servers
      │       ├── Internal APIs
      │       ├── Databases
      │       │
      │       └── Security Group
      │           └── Allows only approved traffic
      │
      ├── Availability Zone 2
      │   │
      │   ├── Public Subnet
      │   │   │
      │   │   ├── Load Balancer / Ingress
      │   │   ├── NAT Gateway (optional)
      │   │   └── Security Group
      │   │
      │   └── Private Subnet
      │       │
      │       ├── Kubernetes Worker Nodes
      │       ├── Application Servers
      │       ├── Databases
      │       └── Security Group
      │
      └── Private Route Table (production setup)
         └── Route:
               0.0.0.0/0 → NAT Gateway
   │
   ├── ECR Registry (Docker Image Storage Service)
   │   └── Stores Docker images built by CI/CD
   │       Example:
   │       devops-stack-app:latest
   │
   ├── Outputs
   │   │
   │   ├── VPC ID
   │   ├── Public subnet IDs
   │   ├── Private subnet IDs
   │   └── ECR repository URL
   │
   v
Kubernetes
   Kubernetes Application Layer
   |
   |-- Base manifests
   |   |-- Namespace
   |   |   |-- Groups all application resources together
   |   |
   |   |-- ConfigMap
   |   |   |-- Provides non-secret app configuration
   |   |   |-- Example: NODE_ENV, PORT, SERVICE_NAME
   |   |
   |   |-- Secret template
   |   |   |-- Shows where sensitive values would go
   |   |   |-- Real secrets should not be committed to Git
   |   |
   |   |-- Deployment
   |   |   |-- Runs the application container as Pods
   |   |   |-- Defines replicas, health checks, resources, and security settings
   |   |
   |   |-- Service
   |   |   |-- Gives Pods a stable internal network address
   |   |   |-- Routes traffic to healthy application Pods
   |   |
   |   |-- Ingress template
   |   |   |-- Defines how external HTTP traffic reaches the Service
   |   |   |-- Intended for use with an ingress controller
   |   |
   |   |-- HPA
   |       |-- Scales application Pods based on CPU usage
   |
   |-- Dev overlay
       |-- Reuses the base manifests
       |-- Applies development-specific changes
       |-- Example: lower replica count for local/dev usage
   |
   v
Monitoring
   |-- health endpoints
   |-- logs
   |-- metrics strategy
   |-- alert recommendations
```

## Repository layout

```text
.
├── .github/workflows/ci.yml
├── docker-compose/
│   ├── docker-compose.yml
│   ├── .env.example
│   └── app/
│       ├── Dockerfile
│       ├── package.json
│       └── server.js
├── k8s/
│   ├── base/
│   │   ├── namespace.yaml
│   │   ├── configmap.yaml
│   │   ├── secret.example.yaml
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── ingress.yaml
│   │   ├── hpa.yaml
│   │   └── kustomization.yaml
│   └── overlays/dev/
│       ├── kustomization.yaml
│       └── patch-replicas.yaml
├── monitoring/
│   ├── README.md
│   └── dashboards-and-alerts.md
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── versions.tf
│   ├── terraform.tfvars.example
│   └── modules/networking/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── scripts/
    ├── bootstrap.sh
    ├── validate.sh
    └── deploy-k8s.sh
```

## Prerequisites

Install:

- Docker
- Docker Compose
- Terraform >= 1.6
- kubectl
- AWS CLI
- GitHub CLI optional

## Quick start: local Docker Compose

```bash
cd docker-compose
cp .env.example .env
docker compose up --build
```

Open:

```text
http://localhost:8080/health
```

Expected response:

```json
{"status":"ok","service":"devops-stack"}
```

## Terraform AWS starter

This Terraform starter creates a small AWS foundation:

- VPC
- public subnets
- private subnets
- internet gateway
- route tables
- ECR repository for container images

It is intentionally EKS-ready without creating an expensive cluster by default.

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

To apply:

```bash
terraform apply
```

To destroy:

```bash
terraform destroy
```

## Kubernetes deployment

Before deploying, update the image value in `k8s/base/deployment.yaml`.

For local clusters such as kind, minikube, or Docker Desktop Kubernetes:

```bash
kubectl apply -k k8s/overlays/dev
kubectl -n devops-stack get all
```

Port-forward locally:

```bash
kubectl -n devops-stack port-forward svc/startup-api 8080:80
curl http://localhost:8080/health
```

## CI/CD workflow

The GitHub Actions workflow performs:

- repository checkout
- Node.js dependency install
- app tests
- Docker image build
- Terraform formatting check
- Terraform validation
- Kubernetes manifest validation using kubectl dry-run

See `.github/workflows/ci.yml`.

## Deployment maturity model for startups

### Stage 1: Manual deploys

Symptoms:

- SSH into servers
- manually run Docker commands
- copy `.env` files between machines
- no deployment history
- no consistent rollback plan

### Stage 2: Scripted deploys

Improvements:

- repeatable shell scripts
- standard build commands
- documented environment variables
- basic smoke tests

### Stage 3: CI/CD deploys

Improvements:

- automated pull request checks
- automated image builds
- repeatable release process
- artifacts tagged by commit SHA
- environment-specific promotion

### Stage 4: Platform foundation

Improvements:

- Terraform-managed infrastructure
- Kubernetes or managed container platform
- central logging and metrics
- alerting and runbooks
- security scanning and quality gates

This repository demonstrates the transition from Stage 1 toward Stage 3 and prepares for Stage 4.

## Production considerations

Before using this in a real production environment, add:

- remote Terraform state with locking, such as S3 + DynamoDB
- IAM roles with least privilege
- secret management through AWS Secrets Manager, SSM Parameter Store, External Secrets Operator, or Sealed Secrets
- container image scanning
- Kubernetes network policies
- TLS certificates through cert-manager or AWS ACM
- centralized logs through CloudWatch, OpenSearch, Datadog, Grafana Loki, or similar
- metrics through Prometheus/Grafana or a managed observability platform
- automated rollback strategy
- blue/green or canary deployments

## Skills demonstrated

This repository demonstrates practical knowledge of:

- DevOps architecture
- infrastructure as code
- Docker containerization
- Kubernetes deployment patterns
- CI/CD pipeline design
- cloud starter architecture on AWS
- release automation
- monitoring strategy
- operational documentation

## License

MIT
