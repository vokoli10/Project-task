Here we Wrote a simple bash script that deploys a kind cluster locally. 
The Kind approcah simply means this cluster is built and enacted locally on your system unlike the Minikube and K3s approach. 
After this, we downloaded the Kube config file as you can see. This file will be used much later. 
After this, we ensured kind was up and running, i created a simple hello-world-app using Nodejs express and deployed to Dockerhub. 
I wrote a Kubernetes manifest deployment file.(However, not to be deployed yet) as we will ue Terraform for that process.
Using kubectl terraform provider, i wrote a terraform code to deploy the kubectl manifest to the kind cluster.
