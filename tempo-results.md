
## Ruben's results
### 1
4504.88 per second (90000) - Running 4 hours 
Drop some spans each hour
  3h running - drop 375 spans/second
  1hr late - drop 981 spans/second
  1hr late - drop 314 spans/second

Distributor Memory: 1.26 GB
Ingestor Memory: 1.5 GB

CPU Spikes in the ingestor, match with the flushes to backend storage

### 2

85000 per second (85000) - Running 4 hours

Default settings No dropping spans, 

NAME                                                              CPU(cores)   MEMORY(bytes)   
tempo-cluster-tempo-distributed-compactor-776d77f664-v27sv        4m           178Mi           
tempo-cluster-tempo-distributed-distributor-6d6c6bcff7-dsjg9      56m          1216Mi          
tempo-cluster-tempo-distributed-ingester-0                        730m         1472Mi          
tempo-cluster-tempo-distributed-querier-5c55c66f58-mtbbd          34m          478Mi           
tempo-cluster-tempo-distributed-query-frontend-7d8d4b8fcb-sx9pt   5m           133Mi    

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
