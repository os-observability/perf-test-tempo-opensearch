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

## Check Kubernetes resources
```bash
kubectl describe nodes kind-control-plane
```

```bash
kubectl top pod -n test-opensearch   
```

## Results

### OpenSearch

Max ingestion rate for a single jaeger-collector? / When ES will start dropping data?

no drop (some here and there) 4500 spans/s
```bash
      # default is 50
      collector.num-workers: 20
      # default is 2000
      # for 400k memory is ~1463Mi
      collector.queue-size: 4000
      es.num-shards: 3
      es.num-replicas: 1
      # default 1
      es.bulk.workers: 3000
      # default 5000000
      es.bulk.size: 5000000
      # default 1000
      es.bulk.actions: 1000
      # default 200ms
```

no drop 4300 spans/s
```bash
      # default is 50
      collector.num-workers: 20
      # default is 2000
      # for 400k memory is ~1463Mi
      collector.queue-size: 4000
      es.num-shards: 3
      es.num-replicas: 1
      # default 1
      es.bulk.workers: 2000
      # default 5000000
      es.bulk.size: 5000000
      # default 1000
      es.bulk.actions: 1000
      # default 200ms
      es.bulk.flush-interval: 200ms
```

No drop as well
```bash
      # default is 50
      collector.num-workers: 20
      # default is 2000
      # for 400k memory is ~1463Mi
      collector.queue-size: 4000
      es.num-shards: 3
      es.num-replicas: 1
      # default 1
      es.bulk.workers: 150
      # default 5000000
      es.bulk.size: 5000000
      # default 1000
      es.bulk.actions: 1000
      # default 200ms
      es.bulk.flush-interval: 200ms
```

no drop 4400 spans/s. 

```bash
    replicas: 1
    options:
      # default is 50
      collector.num-workers: 20
      # default is 2000
      # for 400k memory is ~1463Mi
      collector.queue-size: 4000
      es.num-shards: 3
      es.num-replicas: 1
      # default 1
      es.bulk.workers: 150
      # default 5000000
      es.bulk.size: 5000000
      # default 1000
      es.bulk.actions: 1000
      # default 200ms
      es.bulk.flush-interval: 200ms
```

#### 1
No dropping 2200 spans/s  

- after 1.5h it started dropping data (with queries)

```bash
      "rootRoutes": [
        {
          "service": "frontend",
          "route": "/product",
          "tracesPerHour": 40000
        },
        {
          "service": "frontend",
          "route": "/alt_product_0",
          "tracesPerHour": 40000
        },
        {
          "service": "frontend",
          "route": "/alt_product_1",
          "tracesPerHour": 40000
        },
        {
          "service": "frontend",
          "route": "/alt_product_2",
          "tracesPerHour": 40000
        }
      ]
      
        collector:
    replicas: 1
    options:
      # default is 50
      collector.num-workers: 20
      # default is 2000
      # for 400k memory is ~1463Mi
      collector.queue-size: 4000
      es.num-shards: 3
      es.num-replicas: 1
      # default 1
      es.bulk.workers: 150
      # default 5000000
      es.bulk.size: 5000000
      # default 1000
      es.bulk.actions: 1000
      # default 200ms
      es.bulk.flush-interval: 200ms
```

## Related links
* Grafana Tempo capacity planning https://github.com/grafana/tempo/issues/1540
* Grafana Mimir capacity planning https://github.com/grafana/mimir/issues/1988
