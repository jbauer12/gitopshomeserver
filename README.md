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
kubectl port-forward service/argocd-server -n argocd 8080:443

1Om4SwVwuZtDXVQu

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


## TODO
- Automate it with Terraform / Ansible


