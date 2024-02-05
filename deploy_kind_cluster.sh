#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
	    echo "Docker could not be found. Please install Docker before proceeding."
	        exit 1
fi

# Check if kind is installed
if ! command -v kind &> /dev/null
then
	    echo "kind could not be found. Please install kind before proceeding."
	        exit 1
fi

# Define the cluster configuration
CLUSTER_NAME="cluster1"
CLUSTER_CONFIG=$(cat <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
EOF
)                                                                                                                         # Deploy the cluster
echo "Deploying the Kubernetes cluster: $CLUSTER_NAME..."
echo "$CLUSTER_CONFIG" | kind create cluster --name "$CLUSTER_NAME" --config=-

# Check if the cluster is successfully deployed
if kind get clusters | grep -q "$CLUSTER_NAME"; then
	    echo "Kubernetes cluster $CLUSTER_NAME deployed successfully."
    else
	        echo "Failed to deploy Kubernetes cluster $CLUSTER_NAME."
		    exit 1
fi

