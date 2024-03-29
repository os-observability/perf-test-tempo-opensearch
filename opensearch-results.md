# OpenSearch perf tests results

This section answers the following questions:
* What is the maximum ingestion rate for a single jaeger-collector? 
* When ES will start dropping data?

## Guides for tuning Jaeger-collector parameters

Jaeger collector has a number of workers that call storage API (e.g. store a single span).
The number of workers is configurable and as well queue length of spans. 

```yaml
# default is 50
collector.num-workers: 20
# default is 2000
collector.queue-size: 4000
```

However, the storage API (storage layer in Jaeger) for OpenSearch is not executed synchronously from the worker.
The Jaeger OpenSearch storage implementation uses as well workers and queue for operations submitted to the OpenSearch.
Each bulk worker maintains a list of OpenSearch operations (e.g. index) and submits the request if criteria are
met (number of operations, size, flush interval). 

```yaml
# default 1
es.bulk.workers: 100
# default 5000000
es.bulk.size: 5000000
# default 1000
es.bulk.actions: 1000
# default 200ms
es.bulk.flush-interval: 200ms
```

Jaeger collector workers sends data to the OpenSearch workers via a blocking channel. Therefore, it is
important to have a free OpenSearch worker available otherwise collector workers get blocked and collector
queues start to fill up start dropping spans.

Bulk requests to OpenSearch takes some time, therefore the number of bulk workers should be higher than
collector workers. However, if the number of bulk workers is too high the OpenSearch can start failing the
bulk requests (via [429 too many concurrent requests](https://aws.amazon.com/premiumsupport/knowledge-center/opensearch-resolve-429-error/)).
The ideal total number of bulk works in an instance could be around 150.

## Results

The tests were using 3 node OpenSearch cluster with 3 primary and 1 replica shards. Xmx and Xms are set to half of the pod RAM amount.

### Hardware

* Intel(R) Core(TM) i7-9850H CPU @ 2.60GHz
* 32 GB RAM
* SSD SAMSUNG MZVLB512HBJQ-000L7

### Aggregated results

#### OpenSearch 3x{1GB, 1000m}

1650 spans/second (see the run number #3).

Increasing memory to 1.5GB did not increase ingestion rate.

#### OpenSearch 3x {1GB, 1500m}

3328.41 spans/second (see the number #10). Some spans were dropped at the beginning (5-10 initial minutes).

### 1
No dropping 2200 spans/s

- after 1.5h it started dropping data (with queries)
- with queries, it is dropping around 600-1000 spans/s

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

### 2

1100 spans/s. No droppings spans at all (including query).

```bash
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
        }
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


opensearch-cluster-master-0             340m         880Mi
opensearch-cluster-master-1             243m         877Mi
opensearch-cluster-master-2             692m         869Mi
simple-prod-collector-89887b99f-8kh7g   170m         56Mi
simple-prod-query-fb8dd9f84-hxwqw	4m           65Mi
```

### 3

1650 spans/second. No dropping with query

```bash
      "rootRoutes": [
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
      
      NAME                                    CPU(cores)   MEMORY(bytes)
opensearch-cluster-master-0             409m         851Mi
opensearch-cluster-master-1             379m         839Mi
opensearch-cluster-master-2             546m         858Mi
simple-prod-collector-89887b99f-8kh7g   209m         90Mi
simple-prod-query-fb8dd9f84-hxwqw	54m          84Mi
```

### 4

2216.57 per second dropping around 1000 spans/second

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
      
      NAME                                    CPU(cores)   MEMORY(bytes)
opensearch-cluster-master-0             1095m        931Mi
opensearch-cluster-master-1             1022m        908Mi
opensearch-cluster-master-2             1078m        914Mi
simple-prod-collector-89887b99f-5xkcs   336m         977Mi
simple-prod-query-fb8dd9f84-d72ng	10m          67Mi
```

### 5

1963.22 per second dropping around 100 spans (up to 800 spans/sec) in the collector queue, but the bulk processor is dropping spans as well

```bash
      "rootRoutes": [
        {
          "service": "frontend",
          "route": "/product",
          "tracesPerHour": 35000
        },
        {
          "service": "frontend",
          "route": "/alt_product_0",
          "tracesPerHour": 35000
        },
        {
          "service": "frontend",
          "route": "/alt_product_1",
          "tracesPerHour": 35000
        },
        {
          "service": "frontend",
          "route": "/alt_product_2",
          "tracesPerHour": 35000
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
      
      NAME                                    CPU(cores)   MEMORY(bytes)
opensearch-cluster-master-0             1108m        879Mi
opensearch-cluster-master-1             999m         903Mi
opensearch-cluster-master-2             1061m        904Mi
simple-prod-collector-89887b99f-2txfm   216m         905Mi
simple-prod-query-fb8dd9f84-xmgmd	10m          51Mi
```

### 6

1960.55 per second - no dropping with queries

```
      "rootRoutes": [
        {
          "service": "frontend",
          "route": "/product",
          "tracesPerHour": 35000
        },
        {
          "service": "frontend",
          "route": "/alt_product_0",
          "tracesPerHour": 35000
        },
        {
          "service": "frontend",
          "route": "/alt_product_1",
          "tracesPerHour": 35000
        },
        {
          "service": "frontend",
          "route": "/alt_product_2",
          "tracesPerHour": 35000
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
      es.bulk.workers: 100
      # default 5000000
      es.bulk.size: 5000000
      # default 1000
      es.bulk.actions: 1000
      # default 200ms
      es.bulk.flush-interval: 200ms
      
      NAME                                     CPU(cores)   MEMORY(bytes)
opensearch-cluster-master-0              392m         816Mi
opensearch-cluster-master-1              405m         830Mi
opensearch-cluster-master-2              321m         863Mi
simple-prod-collector-5c4bc6578b-tm2f8   152m         94Mi
simple-prod-query-fb8dd9f84-nnkng        12m          54Mi

      ES - should it be here?
      resources:
  requests:
    # 1000m equals to 1 CPU
    cpu: "1000m"
    memory: "100Mi"
  limits:
    cpu: "1500m"
    memory: "1000Mi"

```

### 7

2224.79 per second, no dropping query running. (90 batch requests failed at the beginning)

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
      es.bulk.workers: 100
      # default 5000000
      es.bulk.size: 5000000
      # default 1000
      es.bulk.actions: 1000
      # default 200ms
      es.bulk.flush-interval: 200ms
      
      opensearch-cluster-master-0              318m         764Mi
opensearch-cluster-master-1              725m         791Mi
opensearch-cluster-master-2              902m         774Mi
simple-prod-collector-5c4bc6578b-tm2f8   230m         109Mi
simple-prod-query-fb8dd9f84-nnkng        126m         125Mi


      ES - should it be here?
      resources:
  requests:
    # 1000m equals to 1 CPU
    cpu: "1000m"
    memory: "100Mi"
  limits:
    cpu: "1500m"
    memory: "1000Mi"

```

### 8
2781.01 per second -- dropping spans 1500 spans/sec

```bash
      "rootRoutes": [
        {
          "service": "frontend",
          "route": "/product",
          "tracesPerHour": 50000
        },
        {
          "service": "frontend",
          "route": "/alt_product_0",
          "tracesPerHour": 50000
        },
        {
          "service": "frontend",
          "route": "/alt_product_1",
          "tracesPerHour": 50000
        },
        {
          "service": "frontend",
          "route": "/alt_product_2",
          "tracesPerHour": 50000
        }
      ]
      
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
      es.bulk.workers: 100
      # default 5000000
      es.bulk.size: 5000000
      # default 1000
      es.bulk.actions: 1000
      # default 200ms
      es.bulk.flush-interval: 200ms
      
      opensearch-cluster-master-0              609m         876Mi
opensearch-cluster-master-1              736m         878Mi
opensearch-cluster-master-2              1199m        879Mi
simple-prod-collector-5c4bc6578b-8xmdg   219m         756Mi
simple-prod-query-fb8dd9f84-ch6z9        13m          40Mi
```

### 9

2778.87 per second - no dropping spans (only at init-time), query running

```bash
      "rootRoutes": [
        {
          "service": "frontend",
          "route": "/product",
          "tracesPerHour": 50000
        },
        {
          "service": "frontend",
          "route": "/alt_product_0",
          "tracesPerHour": 50000
        },
        {
          "service": "frontend",
          "route": "/alt_product_1",
          "tracesPerHour": 50000
        },
        {
          "service": "frontend",
          "route": "/alt_product_2",
          "tracesPerHour": 50000
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
      es.bulk.workers: 100
      # default 5000000
      es.bulk.size: 5000000
      # default 1000
      es.bulk.actions: 1000
      # default 200ms
      es.bulk.flush-interval: 200ms
      
      NAME                                     CPU(cores)   MEMORY(bytes)
opensearch-cluster-master-0              753m         785Mi
opensearch-cluster-master-1              409m         787Mi
opensearch-cluster-master-2              618m         863Mi
simple-prod-collector-5c4bc6578b-6qgct   195m         126Mi
simple-prod-query-fb8dd9f84-fn4nw        5m           91Mi

ES
resources:
  requests:
    # 1000m equals to 1 CPU
    cpu: "1000m"
    memory: "100Mi"
  limits:
    cpu: "1500m"
    memory: "1000Mi"

```

### 10

3328.41 per second - not droppings spans (only at init time), query running

```bash
      "rootRoutes": [
        {
          "service": "frontend",
          "route": "/product",
          "tracesPerHour": 60000
        },
        {
          "service": "frontend",
          "route": "/alt_product_0",
          "tracesPerHour": 60000
        },
        {
          "service": "frontend",
          "route": "/alt_product_1",
          "tracesPerHour": 60000
        },
        {
          "service": "frontend",
          "route": "/alt_product_2",
          "tracesPerHour": 60000
        }
      
      
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
      es.bulk.workers: 100
      # default 5000000
      es.bulk.size: 5000000
      # default 1000
      es.bulk.actions: 1000
      # default 200ms
      es.bulk.flush-interval: 200ms
      
      NAME                                     CPU(cores)   MEMORY(bytes)
opensearch-cluster-master-0              753m         871Mi
opensearch-cluster-master-1              443m         758Mi
opensearch-cluster-master-2              679m         795Mi
simple-prod-collector-5c4bc6578b-pntwj   275m         116Mi
simple-prod-query-fb8dd9f84-8xvdp        8m           68Mi

ES
resources:
  requests:
    # 1000m equals to 1 CPU
    cpu: "1000m"
    memory: "100Mi"
  limits:
    cpu: "1500m"
    memory: "1000Mi"
```

### 11

3921.49 per second - (some at init time in bulk processor, some drops in queues as well 10-150 spans/s), query running

dropping quite a lot (1400-2200 spans/s) even with two collectors (50 workers each) or a single collector 120 workers

```bash
     "rootRoutes": [
        {
          "service": "frontend",
          "route": "/product",
          "tracesPerHour": 70000
        },
        {
          "service": "frontend",
          "route": "/alt_product_0",
          "tracesPerHour": 70000
        },
        {
          "service": "frontend",
          "route": "/alt_product_1",
          "tracesPerHour": 70000
        },
        {
          "service": "frontend",
          "route": "/alt_product_2",
          "tracesPerHour": 70000
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
      es.bulk.workers: 100
      # default 5000000
      es.bulk.size: 5000000
      # default 1000
      es.bulk.actions: 1000
      # default 200ms
      es.bulk.flush-interval: 200ms
      
NAME                                     CPU(cores)   MEMORY(bytes)
opensearch-cluster-master-0              513m         777Mi
opensearch-cluster-master-1              978m         856Mi
opensearch-cluster-master-2              813m         822Mi
simple-prod-collector-5c4bc6578b-bxnmz   449m         162Mi
simple-prod-query-fb8dd9f84-sptsc        7m           53Mi
      

      ES
      resources:
  requests:
    # 1000m equals to 1 CPU
    cpu: "1000m"
    memory: "100Mi"
  limits:
    cpu: "1500m"
    memory: "1000Mi"
```
