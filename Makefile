.PHONY: build
build:
	uv build -q

.PHONY: docker-build
docker-build: build
	JAVA_HOME=$$(/usr/libexec/java_home -v 17) \
	eval $$(minikube -p minikube docker-env) && \
	docker build -t pyspark-kubernetes:latest .

.PHONY: run-local
run-local: build
	JAVA_HOME=$$(/usr/libexec/java_home -v 17) spark-submit --py-files dist/pyspark_kubernetes-0.1.0-py3-none-any.whl main.py

.PHONY: clean
clean:
	rm -rf dist .venv *.egg-info __pycache__

.PHONY: kube-apply
kube-apply:
	kubectl apply -k deploy/

.PHONY: start
start:
	minikube start

.PHONY: run-cluster
run-cluster: docker-build kube-apply
	JAVA_HOME=$$(/usr/libexec/java_home -v 17) \
	eval $$(minikube -p minikube docker-env) && \
	spark-submit \
		--master k8s://$$(kubectl config view | yq ".clusters | .[-1] | .cluster | .server") \
		--conf spark.executor.instances=5 \
		--conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
		--conf spark.kubernetes.container.image=pyspark-kubernetes:latest \
		--conf spark.kubernetes.namespace=spark \
		--deploy-mode cluster \
		local:///app/main.py

