## Development Setup for trying
Installing k3d:
```bash
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```
start cluster
```bash
k3d cluster create --k3s-arg "--disable=traefik@server:0"
#or multi node cluster
k3d cluster create gitopshomeserver \
  --servers 1 \
  --agents 3 \
  --k3s-arg "--disable=traefik@server:0"

``` 

## First Steps
Install k3s and disable traefik
```bash
curl -sfL https://get.k3s.io | sh -s - --disable traefik
sudo chown $(whoami):$(whoami) /etc/rancher/k3s/k3s.yaml
```
```bash
curl https://get.helm.sh/helm-v3.10.2-linux-amd64.tar.gz -o helm-v3.10.2-linux-amd64.tar.gz
tar -zxvf helm-v3.10.2-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
helm version

```

- Install ArgoCD 

```bash
kubectl create namespace argocd

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm install argocd argo/argo-cd -n argocd --set server.insecure=true

```
### Login to ArgoCD
get initial password
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
port forward (proviosnally)
```bash
kubectl port-forward service/argocd-server -n argocd 8080:80

```

### Install ArgoCD CLI
```bash
VERSION=$(curl -s https://api.github.com/repos/argoproj/argo-cd/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -sSL -o argocd "https://github.com/argoproj/argo-cd/releases/download/${VERSION}/argocd-$(uname -s)-amd64"
chmod +x argocd
sudo mv argocd /usr/local/bin/
argocd login localhost:8080
```
### Setup App of Apps
docu: https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/ 
```bash
argocd app create apps \
    --dest-namespace argocd \
    --dest-server https://kubernetes.default.svc \
    --repo  https://github.com/jbauer12/gitopshomeserver \
    --path apps
argocd app sync apps  ;
```
## Sealed Secrets
To store secrets in a gitops manner while ensuring security in this repo [SealedSecrets](https://github.com/bitnami-labs/sealed-secrets) is used.

Steps and How to create and work with Sealed Secrets:
```bash
#Install jq to use the script 
sudo apt update
sudo apt install jq
#install kubseal which is used to encrypt secrets
KUBESEAL_VERSION='' # Set this to, for example, KUBESEAL_VERSION='0.23.0'
# Fetch the latest sealed-secrets version using GitHub API
KUBESEAL_VERSION=$(curl -s https://api.github.com/repos/bitnami-labs/sealed-secrets/tags | jq -r '.[0].name' | cut -c 2-)

# Check if the version was fetched successfully
if [ -z "$KUBESEAL_VERSION" ]; then
    echo "Failed to fetch the latest KUBESEAL_VERSION"
    exit 1
fi

curl -OL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz"
tar -xvzf kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
```
Now it can be used with this command:
```bash
kubeseal -f example_secret.yaml -w mysealedsecret.yaml --controller-name sealed-secrets --controller-namespace kube-system
```



##



## TODO

Use Software:
- Immich
- Nextcloud or Opencloud
- Paperless

Implement:
- Kube-VIP
- Prometheus & Grafana

