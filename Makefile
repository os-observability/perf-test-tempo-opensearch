
.PHONY: start-minikube
start-minikube:
	minikube start --memory=20g --cpus=8 --disk-size=50g --bootstrapper=kubeadm --extra-config=kubelet.authentication-token-webhook=true --extra-config=kubelet.authorization-mode=Webhook --extra-config=scheduler.bind-address=0.0.0.0 --extra-config=controller-manager.bind-address=0.0.0.0  --docker-opt="default-ulimit=nofile=102400:102400"
	#minikube start --memory=20g --cpus=8 --bootstrapper=kubeadm --extra-config=kubelet.authentication-token-webhook=true --extra-config=kubelet.authorization-mode=Webhook --extra-config=scheduler.bind-address=0.0.0.0 --extra-config=controller-manager.bind-address=0.0.0.0
	minikube ssh "sudo sysctl -w vm.max_map_count=262144" # VM restart might be needed

.PHONY: deploy-monitoring
deploy-monitoring:
	git submodule update --init --recursive
	kubectl apply --server-side -f kube-prometheus/manifests/setup
	until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
	kubectl apply -f kube-prometheus/manifests/

.PHONY: deploy-jaeger-operator
deploy-jaeger-operator:
	kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.yaml
	sleep 50 # wait until cert manager is up and ready
	kubectl create namespace observability || true
	kubectl apply -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.35.0/jaeger-operator.yaml -n observability # <2>

.PHONY: deploy-test-opensearch
deploy-test-opensearch:
	kubectl create namespace test-opensearch || true
	helm repo add opensearch https://opensearch-project.github.io/helm-charts/
	# deploy OpenSearch 1.3.3
	helm install opensearch-cluster -f ./resources-opensearch/helm-values/opensearch-helm-values.yaml --namespace test-opensearch opensearch/opensearch --version 1.13.0 || true
	kubectl apply -f ./resources-opensearch -n test-opensearch

.PHONY: deploy-opensearch-query-load-generator
deploy-opensearch-query-load-generator:
	kubectl create namespace tracegen || true
	kubectl create configmap queries --from-file=./query-load-generator/queries.txt -o yaml --dry-run=client | kubectl apply -n tracegen -f -
	sed 's/#QUERY_URL#/http:\/\/simple-prod-query.test-opensearch.svc:16686/' query-load-generator/query-load-generator.yaml \
	| sed 's/#NAMESPACE#/opensearch/'\
	| kubectl apply -n tracegen -f -

.PHONY: deploy-tempo-query-load-generator
deploy-tempo-query-load-generator:
	kubectl create namespace tracegen || true
	kubectl create configmap queries --from-file=./query-load-generator/queries.txt -o yaml --dry-run=client | kubectl apply -n tracegen -f -
	sed 's/#QUERY_URL#/http:\/\/tempo-cluster-tempo-distributed-query-frontend.test-tempo.svc:16686/' query-load-generator/query-load-generator.yaml \
	| sed 's/#NAMESPACE#/tempo/'\
	| kubectl apply -n tracegen -f -

.PHONY: port-forward-grafana
port-forward-grafana:
	kubectl port-forward svc/grafana 3000:3000 -n monitoring

.PHONY: port-forward-opensearch
port-forward-opensearch:
	#http://localhost:9200/_cat/indices?v=true
	kubectl port-forward svc/opensearch-cluster-master 9200:9200 -n test-opensearch

.PHONY: port-forward-jaeger-test-opensearch
port-forward-jaeger-test-opensearch:
	kubectl port-forward svc/simple-prod-query 16686:16686 -n test-opensearch

.PHONY: port-forward-prometheus
port-forward-prometheus:
	kubectl port-forward svc/prometheus-k8s 9090:9090 -n monitoring

.PHONY: deploy-test-tempo
deploy-test-tempo:
	kubectl create namespace test-tempo || true
	kubectl create namespace minio || true
	helm repo add minio https://charts.min.io/
	helm install minio -f resources-tempo/helm-values/minio-helm-values.yaml --namespace minio minio/minio --version 4.0.5 || true
	helm repo add grafana https://grafana.github.io/helm-charts
	helm install tempo-cluster -f resources-tempo/helm-values/tempo-helm-values.yaml --namespace test-tempo grafana/tempo-distributed --version 0.21.6 || true
	kubectl apply -f ./resources-tempo -n test-tempo


.PHONY: port-forward-jaeger-test-tempo
port-forward-jaeger-test-tempo:
	kubectl port-forward svc/tempo-cluster-tempo-distributed-query-frontend 16686:16686  -n test-tempo

.PHONY: port-forward-minio
port-forward-minio:
	kubectl port-forward minio-0 9001 --namespace minio

.PHONY: deploy-tracegen-opensearch
deploy-tracegen-opensearch: deploy-opensearch-query-load-generator
	kubectl create namespace tracegen || true
	sed 's/#COLLECTOR_URL#/http:\/\/simple-prod-collector.test-opensearch.svc:14268/' load-generator.yaml | kubectl apply -n tracegen -f -


.PHONY: deploy-tracegen-tempo
deploy-tracegen-tempo: deploy-tempo-query-load-generator
	kubectl create namespace tracegen || true
	sed 's/#COLLECTOR_URL#/http:\/\/tempo-cluster-tempo-distributed-distributor.test-tempo.svc:14268/' load-generator.yaml | kubectl apply -n tracegen -f -

.PHONY: port-forward-query-api-tempo
port-forward-query-api-tempo:
	kubectl port-forward svc/tempo-cluster-tempo-distributed-query-frontend 3100:3100  -n test-tempo
