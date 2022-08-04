- 53 spans/second, no drop


```yaml
  resources:
    requests:
      cpu: 400m
      memory: 400Mi
    limits:
      cpu: "400m"
      memory: "400Mi"
```


```yaml
      "rootRoutes": [
        {
          "service": "frontend",
          "route": "/product",
          "tracesPerHour": 1000
        },
        {
          "service": "frontend",
          "route": "/alt_product_0",
          "tracesPerHour": 1000
        },
        {
          "service": "frontend",
          "route": "/alt_product_1",
          "tracesPerHour": 1000
        },
        {
          "service": "frontend",
          "route": "/alt_product_2",
          "tracesPerHour": 1000
        }
      ]
    }

```

- distributor dies with OOM 
  300 spans/second - peak of 500 spans/sec, 

```yaml
  resources:
    requests:
      cpu: 400m
      memory: 400Mi
    limits:
      cpu: "400m"
      memory: "400Mi"
```

Same with:

```yaml
  resources:
    requests:
      cpu: 400m
      memory: 600Mi
    limits:
      cpu: "400m"
      memory: "600Mi"
```

```yaml
         {
          "service": "frontend",
          "route": "/product",
          "tracesPerHour": 10000
        },
        {
          "service": "frontend",
          "route": "/alt_product_0",
          "tracesPerHour": 10000
        },
        {
          "service": "frontend",
          "route": "/alt_product_1",
          "tracesPerHour": 10000
        },
        {
          "service": "frontend",
          "route": "/alt_product_2",
          "tracesPerHour": 10000
        }
```



500 spans/second 

Distributor behave fine, but ingestor start to dropping
spans after 5 minutes, more and more until it ends dropping all.

```yaml
distributor:
  replicas: 1
  affinity: {}
  resources:
    requests:
      cpu: 400m
      memory: 1000Mi
    limits:
      cpu: "400m"
      memory: "1000Mi"
```

All other components:

```yaml
  resources:
    requests:
      cpu: 400m
      memory: 100Mi
    limits:
      cpu: "400m"
      memory: "100Mi"
```




- 528 spans/second 


```yaml
ingester:
  replicas: 1
  config:
    replication_factor: 1
  resources:
    requests:
      cpu: 400m
      memory: 1000Mi
    limits:
      cpu: "400m"
      memory: "1000Mi"
distributor:
  replicas: 1
  affinity: {}
  resources:
    requests:
      cpu: 400m
      memory: 1000Mi
    limits:
      cpu: "400m"
      memory: "1000Mi"
querier:
  resources:
    requests:
      cpu: 400m
      memory: 100Mi
    limits:
      cpu: "400m"
      memory: "100Mi"
```

```yaml
        {
          "service": "frontend",
          "route": "/product",
          "tracesPerHour": 10000
        },
        {
          "service": "frontend",
          "route": "/alt_product_0",
          "tracesPerHour": 10000
        },
        {
          "service": "frontend",
          "route": "/alt_product_1",
          "tracesPerHour": 10000
        },
        {
          "service": "frontend",
          "route": "/alt_product_2",
          "tracesPerHour": 10000
```


- 1140 spans/second, but OOM distributor after 1 minute, restarted and 
 continue working intermitently, the ingestor on the other side didn't reject anything until 30 min passed. 


```yaml
ingester:
  replicas: 1
  config:
    replication_factor: 1
  resources:
    requests:
      cpu: 400m
      memory: 1000Mi
    limits:
      cpu: "400m"
      memory: "1000Mi"
distributor:
  replicas: 1
  affinity: {}
  resources:
    requests:
      cpu: 400m
      memory: 1000Mi
    limits:
      cpu: "400m"
      memory: "1000Mi"
querier:
  resources:
    requests:
      cpu: 400m
      memory: 100Mi
    limits:
      cpu: "400m"
      memory: "100Mi"
```

```yaml
        {
          "service": "frontend",
          "route": "/product",
          "tracesPerHour": 30000
        },
        {
          "service": "frontend",
          "route": "/alt_product_0",
          "tracesPerHour": 30000
        },
        {
          "service": "frontend",
          "route": "/alt_product_1",
          "tracesPerHour": 30000
        },
        {
          "service": "frontend",
          "route": "/alt_product_2",
          "tracesPerHour": 30000
```

- 1150 spans/second, no drop spans, no OOM 1 hr running stable

Distributor memory: 1.17GB
Ingestor memory: 773Mb 

```yaml
ingester:
  replicas: 1
  config:
    replication_factor: 1
  resources:
    requests:
      cpu: 400m
      memory: 1000Mi
    limits:
      cpu: "400m"
      memory: "1000Mi"
distributor:
  replicas: 1
  affinity: {}
  resources:
    requests:
      cpu: 400m
      memory: 1500Mi
    limits:
      cpu: "400m"
      memory: "1500Mi"
querier:
  resources:
    requests:
      cpu: 400m
      memory: 100Mi
    limits:
      cpu: "400m"
      memory: "100Mi"
```

```yaml
        {
          "service": "frontend",
          "route": "/product",
          "tracesPerHour": 20000
        },
        {
          "service": "frontend",
          "route": "/alt_product_0",
          "tracesPerHour": 20000
        },
        {
          "service": "frontend",
          "route": "/alt_product_1",
          "tracesPerHour": 20000
        },
        {
          "service": "frontend",
          "route": "/alt_product_2",
          "tracesPerHour": 20000
```

- 2156 spans/second, no drop spans
- Droping queries..

```yaml
ingester:
  replicas: 1
  config:
    replication_factor: 1
  resources:
    requests:
      cpu: 400m
      memory: 1500Mi
    limits:
      cpu: "400m"
      memory: "1500Mi"
distributor:
  replicas: 1
  affinity: {}
  resources:
    requests:
      cpu: 400m
      memory: 1500Mi
    limits:
      cpu: "400m"
      memory: "1500Mi"
querier:
  resources:
    requests:
      cpu: 400m
      memory: 100Mi
    limits:
      cpu: "400m"
      memory: "100Mi"
```

```yaml
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
```

## Pavol's results

### 1
6235.88 per second (110000) - dropping 0 - 1500 spans/second

```bash
NAME                                                              CPU(cores)   MEMORY(bytes)
tempo-cluster-tempo-distributed-compactor-5b7f974d84-fft65        7m           91Mi
tempo-cluster-tempo-distributed-distributor-f74756d48-xfntk	  170m         1232Mi
tempo-cluster-tempo-distributed-ingester-0                        1111m        1497Mi
tempo-cluster-tempo-distributed-querier-877c8d59c-9dl7s           177m         499Mi
tempo-cluster-tempo-distributed-query-frontend-6c64bf5587-xvm8f   200m         220Mi
```

### 2
5552.33 per second  - not dropping for a long time and then dropping 0-1400

```bash
NAME                                                              CPU(cores)   MEMORY(bytes)
tempo-cluster-tempo-distributed-compactor-5b7f974d84-kz8gp        10m          110Mi
tempo-cluster-tempo-distributed-distributor-f74756d48-4tkbt	  201m         1239Mi
tempo-cluster-tempo-distributed-ingester-0                        623m         1498Mi
tempo-cluster-tempo-distributed-querier-877c8d59c-78p2m           161m         499Mi
tempo-cluster-tempo-distributed-query-frontend-598dff6967-xvhfh   159m         184Mi
```

### 3

5100 per second - droping all spans after some time (e.g. 45 min)

### 4

TODO try 90000
