#!/bin/bash

# Setting some variables
export CLUSTER_NAME="techworld"
export NAMESPACE="techworld"
export ARGOCD_NS="argocd"
export DRIVER="docker"
export 
ARGO_URL='https://raw.githubusercontent.com/argoproj/argo-cd/v2.5.8/manifests/install.yaml'
export ARGO_SER='svc/argocd-server'

# Creating the cluster
echo -e "\n Creating the Cluster called $CLUSTER_NAME Now"
sleep 2
minikube  start --driver $DRIVER --profile $CLUSTER_NAME
echo -e "\n\tThe $CLUSTER_NAME Cluster has been created"
sleep 2

# verify the cluster is running
# echo -e "\n\t*** Cluster Created *** "
# CLUSTER_STASTUS=$(minikube status --profile $CLUSTER_NAME)
# echo -e "\t${CLUSTER_STASTUS}"

# Install argo CD and  Components
echo -e "\n\n"
echo "Installing Argo CD and Components"
sleep 2
echo ""
echo "Creating Argo CD ns"
kubectl create namespace $ARGOCD_NS
echo -e "\n\n"

sleep 2
echo "Installing ArgoCD Components"
kubectl apply --namespace $ARGOCD_NS \
  -f $ARGO_URL

sleep 3
echo -e "\n To get the admin secret, run"
echo -e "\nkubectl -n $ARGOCD_NS  get secret 
argocd-initial-admin-secret -o jsonpath="{.data.password}" | 
base64 -d; echo"
echo -e "\n To stop port forwarding, please press control + C"
sleep 2

echo -e "\n\\nARGO CD Installed and Waiting for service to become 
available n\n"
kubectl wait --namespace $ARGOCD_NS --for=condition=Available 
$ARGO_SER --timeout=60s

echo -e "\n Starting port forwarding"
kubectl port-forward $ARGO_SER -n $ARGOCD_NS 8080:443
