#!/bin/bash

# start kubenertes cluster
if [ $# -ne 2 ]; then
    echo "Insufficient Script Parameters, e.g., collect.sh [Cloud Arch] [Attack(1) or Normal(0)]"
    exit 1
fi

script_dir=$(dirname "$(readlink -f "$0")")
cloud_arch=$1 # containerd, crio, gvisor
collect_attack=$2

if [[ "$cloud_arch" == "containerd" ]]; then
  minikube start --kubernetes-version=v1.18.12 --driver=docker --container-runtime=containerd
elif [[ "$cloud_arch" == "crio" ]]; then
  minikube start --kubernetes-version=v1.18.12 --driver=docker --container-runtime=crio
elif [[ "$cloud_arch" == "gvisor" ]]; then
  minikube start --driver=docker --container-runtime=containerd --docker-opt containerd=/var/run/containerd/containerd.sock
  minikube addons enable gvisor
else
    echo "Cloud Arch $arg is not Supported"
fi
sleep 5
kubectl get pods

# run application
kubectl apply -k /CloudAttackRecord/projects/wordpress-6.2.1-apache   

# check if application started
while true; do
  echo "Waiting for the pod creation..."
  sleep 5
  kubectl get pods | grep wordpress | grep "Running"
  if [ $? -eq 0 ]; then
    break
  else
    echo "waiting..."
  fi
done

# Manual setup wordpress
minikube service wordpress --url
read -p "Setup wordpress and press any key to continue..."
# google-chrome $(minikube service web --url)

pushd k8spider/
go build -o bin/k8spider main.go
popd

# if collect_attack is 1, then run attack.sh
if [[ $collect_attack -eq 1 ]]; then
  bash attack.sh CWE-200
fi