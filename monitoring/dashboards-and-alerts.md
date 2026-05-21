# Dashboards and Alerts

## Service dashboard panels

Create a dashboard with these panels:

- request rate by route
- HTTP status code distribution
- p50/p95/p99 latency
- container CPU usage
- container memory usage
- pod restart count
- Kubernetes deployment replica availability
- recent deployment annotations

## Kubernetes commands for incident checks

```bash
kubectl -n devops-stack get pods
kubectl -n devops-stack describe deployment startup-api
kubectl -n devops-stack logs deploy/startup-api --tail=100
kubectl -n devops-stack rollout status deployment/startup-api
```

## Rollback command

```bash
kubectl -n devops-stack rollout undo deployment/startup-api
```

## Smoke test

```bash
kubectl -n devops-stack port-forward svc/startup-api 8080:80
curl -f http://localhost:8080/health
```
