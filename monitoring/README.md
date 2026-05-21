# Monitoring Notes

Monitoring should answer four operational questions:

1. Is the service up?
2. Is the service healthy?
3. Is the service fast enough?
4. Are users or downstream systems impacted?

## Recommended startup baseline

Start with:

- application health endpoints
- structured application logs
- container restart alerts
- CPU and memory alerts
- HTTP error-rate alerts
- latency alerts
- deployment event tracking

## Suggested tools

Cloud-native AWS approach:

- CloudWatch Logs
- CloudWatch Metrics
- AWS Managed Prometheus
- AWS Managed Grafana
- AWS X-Ray for tracing where useful

Open-source Kubernetes approach:

- Prometheus
- Grafana
- Alertmanager
- Loki
- Tempo or Jaeger

SaaS approach:

- Datadog
- New Relic
- Honeycomb
- Grafana Cloud

## Golden signals

Track:

- latency
- traffic
- errors
- saturation

## Example alerts

- API error rate above 5% for 5 minutes
- p95 latency above 1 second for 10 minutes
- pod restart count increased within 10 minutes
- deployment unavailable replicas greater than 0 for 5 minutes
- CPU usage above 80% for 15 minutes
- memory usage above 85% for 15 minutes

## Runbook template

Each alert should have a runbook containing:

- alert meaning
- customer impact
- dashboard link
- first commands to run
- rollback instructions
- escalation contact
