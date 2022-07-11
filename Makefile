
.PHONY: deploy-jaeger-operator
deploy-jaeger-operator:
	kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.yaml
	sleep 10 # wait until cert manager is up and ready
	kubectl create namespace observability || true
	kubectl apply -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.35.0/jaeger-operator.yaml -n observability # <2>

.PHONY: deploy-test-opensearch
deploy-test-opensearch:
	kubectl create namespace test-opensearch
	helm repo add opensearch https://opensearch-project.github.io/helm-charts/
	helm install opensearch-cluster -f opensearch-helm-values.yaml --namespace test-opensearch opensearch/opensearch --version 1.13.0
	kubectl apply -f ./resources -n test-opensearch

.PHONY: deploy-opensearch-operator
deploy-opensearch-operator:
	# Do not forget to run sysctl -w vm.max_map_count=262144 on the cluster
	helm repo add opensearch-operator https://opster.github.io/opensearch-k8s-operator/
	kubectl create namespace opensearch-operator || true
	helm install --namespace opensearch-operator opensearch-operator opensearch-operator/opensearch-operator

.PHONY: minikube-start
minikube-start:
	minikube start --memory=15g --cpus=4 --bootstrapper=kubeadm --extra-config=kubelet.authentication-token-webhook=true --extra-config=kubelet.authorization-mode=Webhook --extra-config=scheduler.bind-address=0.0.0.0 --extra-config=controller-manager.bind-address=0.0.0.0

.PHONY: port-forward-grafana
port-forward-grafana:
	kubectl port-forward svc/grafana 3000:3000 -n monitoring

.PHONY: install-monitoring
install-monitoring:
	git submodule init
	kubectl apply --server-side -f kube-prometheus/manifests/setup
	until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
	kubectl apply -f kube-prometheus/manifests/

