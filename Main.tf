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

