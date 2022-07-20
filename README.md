# Grafana Tempo and Elasticsearch performance comparison

This repository compares resource utilization of Tempo and Elasticsearch.

## Methodology

TBD

## Deploy

### Prepare environment

```bash
make start-minikube
make deploy-monitoring
make deploy-jaeger-operator
make deploy-test-opensearch
```

### Deploy load generator
```bash
kubectl apply -f load-generator.yaml  
```

## Kubernetes node resources
```bash
kubectl describe nodes kind-control-plane
```

## Related links
* Grafana Tempo capacity planning https://github.com/grafana/tempo/issues/1540
* Grafana Mimir capacity planning https://github.com/grafana/mimir/issues/1988
