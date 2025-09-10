# Pyspark Kubernetes Example

This repo contains an example of running a PySpark 4.0.0 job on a kubernetes cluster, specifically, minikube.

## Prerequisites
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) installed
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed
- [Docker](https://docs.docker.com/get-docker/) installed
- [yq](https://github.com/mikefarah/yq) installed (optional - used to parse kubectl output for cluster IP)

## Steps to Run

Most commands are in the `Makefile`.

1. Start minikube:
```shell
make start
```

2. Run the job:
```shell
make run-cluster
```

Note: this will attempt to get the IP address of the cluster using `--master k8s://$$(kubectl config view | yq ".clusters | .[-1] | .cluster | .server") \`
in the `spark-submit` command.
If for any reason this fails you can substitute this with IP returned by `kubectl cluster-info`.

This will install necessary python dependencies, build the Docker image and push it to minikube's Docker registry. 
It will then apply kube `kustomization`'s from the `deploy` directory to create the `Namespace`, `ClusterRole`, `ServiceAccount` and `ClusterRoleBinding`.
Finally, it will submit the PySpark job to the cluster using `spark-submit`.

You can check the status of the job as well as logs using `k9s`:
```shell
k9s -n spark
```
