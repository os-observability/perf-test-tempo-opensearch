.PHONY: deploy-tempo
deploy-tempo:
	apply-manifest.sh

.PHONY: deploy-load-generator
deploy-load-generator:
	oc apply -n tempo-distributed-s3 -f load-generator.yaml

.PHONY: deploy-grafana
deploy-grafana:
	oc apply -f grafana/grafana.yaml
	oc adm policy add-cluster-role-to-user cluster-monitoring-view -z grafana-serviceaccount -n tempo-distributed-s3
	sed -e 's/${TOKEN}/'$(oc serviceaccounts get-token grafana-serviceaccount -n tempo-distributed-s3)'/g' grafana/grafana_datasource.yaml.template | oc apply -f-
	oc apply -f grafana/operational_dashboard.yaml
