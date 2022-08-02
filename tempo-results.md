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

