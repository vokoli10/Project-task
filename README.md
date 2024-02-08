
# Containerized Node.js Application Deployment with Kubernetes and Terraform"
Setup a kubernetes cluster using kind, then create and deploy a sample Node.js app using terraform. 

##
We made a simple script using bash, a type of computer language, to create a local Kind cluster. The name of the script is deploy_kind_cluster.sh.
## deploy_kind_cluster.sh

``` bash

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

```
## Installation

We then ran the bash script using the command below;

```bash
  ./deploy_kind_cluster.sh

```
    
## Our Kind cluster is up and running.
![](https://private-user-images.githubusercontent.com/147929336/303326648-e0a18c42-66a6-4dc5-bf39-b08ce63d85a9.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDczOTU3NzYsIm5iZiI6MTcwNzM5NTQ3NiwicGF0aCI6Ii8xNDc5MjkzMzYvMzAzMzI2NjQ4LWUwYTE4YzQyLTY2YTYtNGRjNS1iZjM5LWIwOGNlNjNkODVhOS5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMjA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDIwOFQxMjMxMTZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT01MWI3NzliMDcyMjEyY2QyODQzZjgwNGFlNDZhMDUzNjQwNzVmMGQ3NTI1MGY1YTg2ZWZjOTc3NWVlYjY2YTI4JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.RfYI0ETyiy46NMhu7dnElLfzvPpzXDbqc5Xvt-q0QoA)
## Few notes on the kind cluster. 
This kind cluster is like a mini version of a real one and is set up right on your own computer locally. We have other method like, minikube, K3s, but we chose kind reason being this is quick to set up. After we have established our nodes are running, we extract the kube config from the (HOME/. kube/config) directory which we will need much later.
## A simple hello-world-app created with Node.js express.
![Node js express](https://private-user-images.githubusercontent.com/147929336/303331245-d9526232-93ac-477d-aad2-5932f80da1a1.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDczOTY0NzAsIm5iZiI6MTcwNzM5NjE3MCwicGF0aCI6Ii8xNDc5MjkzMzYvMzAzMzMxMjQ1LWQ5NTI2MjMyLTkzYWMtNDc3ZC1hYWQyLTU5MzJmODBkYTFhMS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMjA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDIwOFQxMjQyNTBaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT03YzQwZDA3MjMwNTk4MjEzZGVlZWIzNjgzYjZlZTgxNWNkOTY2MjYwMTQ0NzBhMGVkNzRjZjIwNmRhYjdmNGFlJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.R8zBQaHk-k7_RbghU1jXYNvan8hN3sF2OgoudU_-VTY)
## Now inorder to deploy this application to dockerhub, we can do this with the help of a Dockerfile, Here's one;
![Dockerfile](https://private-user-images.githubusercontent.com/147929336/303336379-7d6401c5-3a80-4c9d-9040-14b80883ce7f.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDczOTcyNzIsIm5iZiI6MTcwNzM5Njk3MiwicGF0aCI6Ii8xNDc5MjkzMzYvMzAzMzM2Mzc5LTdkNjQwMWM1LTNhODAtNGM5ZC05MDQwLTE0YjgwODgzY2U3Zi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMjA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDIwOFQxMjU2MTJaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1mMDJiOWM4YzFjMWE1MmNjMzVkZDU2ODM4NjE0MWNiYmNlNGI3YTA3NmEzYWQ3ZWNiYTQxODY5OGIxYWE5MDhiJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.0uvMqk_k3DT7QFPrQKEh5sxorx6Z9uG20BIDFjpeIj8)
## Kubectl Manifest deployment file
Next we create a Manifest deployment file, a tool that manages the kind cluster we created earlier. Below is our Manifest deployment file, let's name it Hello-world-deployment.yaml.

![Manifest-deployment-file](https://private-user-images.githubusercontent.com/147929336/303338309-a7a35c9f-f33a-425f-860a-33a8d045fbbd.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDczOTc3MjksIm5iZiI6MTcwNzM5NzQyOSwicGF0aCI6Ii8xNDc5MjkzMzYvMzAzMzM4MzA5LWE3YTM1YzlmLWYzM2EtNDI1Zi04NjBhLTMzYThkMDQ1ZmJiZC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMjA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDIwOFQxMzAzNDlaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1lYjIxMjg4ZDFlYzdiYTlhMDAzZTczNzg4MDRiNTMwMGFiZmQ4ZTcwYWNmOTY1M2ExNGYwMjA1MDUxZmQxM2VjJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.GtoqDC1JIIGeXo9JVaos875xI4XVzPtMaDeSYu2EGWg)


As seen above, this is a manifest deployment file for the kind cluster created, however we won't apply this just yet, we will use another tool called Terraform to run this Manifest file.

## What is Terraform?
![Terraform](https://private-user-images.githubusercontent.com/147929336/303340183-0f62bcf0-4a9e-481d-b223-5e87ef3c0069.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDczOTgxNTEsIm5iZiI6MTcwNzM5Nzg1MSwicGF0aCI6Ii8xNDc5MjkzMzYvMzAzMzQwMTgzLTBmNjJiY2YwLTRhOWUtNDgxZC1iMjIzLTVlODdlZjNjMDA2OS5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjQwMjA4JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI0MDIwOFQxMzEwNTFaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0yZGUwOTk0ZTkzMjAxYTRjNmE3MGNmMDM2OTE2MDYzMDQ1ODM1ZTRhNmZlZjJjYjA5YmE1ZDEyMDcxYWU1MGVlJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZhY3Rvcl9pZD0wJmtleV9pZD0wJnJlcG9faWQ9MCJ9.3qtITbFHyZfm2BIUwHAIffPCKs2hjHcSpcELzNOrlQQ)






















## Deploying the Maifest file using Terraform.
With Terraform, Using the Kubectl terraform provider, we'll write a terraform code as seen on the Main.tf and the provider.tf that deploys the manifest deployment file to the kind cluster. Below are both the Main.tf and Provider.tf file respectively.

Main.tf

```bash
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" {
  config_path      = "~/.kube/config"
  load_config_file = true
}

resource "kubectl_manifest" "hello_world_app" {
  yaml_body = <<-YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world-app
  labels:
    app: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: nodejs-container
        image: victorokoli/hello-world-app:latest
    YAML
}

resource "helm_release" "prometheus" {
  name       = "prometheus-release"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-community"
}

```

provider.tf

``` bash

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}

```
## Lessons Learned

What did i learn while building this project? What challenges did you face and how did you overcome them?

While building this project, several key learnings and challenges occured such as;

1.Understanding Cluster Technologies: I learned about different Kubernetes cluster technologies like Kind, Minikube, and K3s and their respective use cases. I chose Kind for its ease of setup and lightweight nature.

2.Scripting with Bash: Writing the deployment script (deploy_kind_cluster.sh) in Bash required familiarity with Bash scripting, including commands for setting up the Kind cluster, extracting kube config, and other operations is necessary.

3.Dockerfile Creation: Creating a Dockerfile for the hello-world-app involved understanding Dockerfile syntax and specifying the necessary instructions to build the Docker image containing the Node.js Express application.

4.Kubernetes Manifests: This was a tricky one lol. Writing Kubernetes deployment manifests (hello-world-deployment.yaml) requires understanding Kubernetes object specifications, indentations, including deployments, pods, and services.

5.Terraform Integration: This was the most challengeing.  Integrating Terraform into the workflow involved learning how to use the Kubernetes provider to manage Kubernetes resources using Terraform configuration files (main.tf and provider.tf). This included specifying the Kind cluster as the target and deploying the Kubernetes deployment using Terraform.

