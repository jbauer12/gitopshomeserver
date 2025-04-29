## First Steps
- Install ArgoCD 

```bash
kubectl create namespace argocd

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm install argocd argo/argo-cd -n argocd \
  --set server.service.type=LoadBalancer
```
### Login to ArgoCD
get initial password
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
port forward (proviosnally)
```bash
kubectl port-forward service/argocd-server -n argocd 8080:443
```
### Install ArgoCD CLI
```bash
VERSION=$(curl -s https://api.github.com/repos/argoproj/argo-cd/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -sSL -o argocd "https://github.com/argoproj/argo-cd/releases/download/${VERSION}/argocd-$(uname -s)-amd64"
chmod +x argocd
sudo mv argocd /usr/local/bin/
argocd login localhost:8080
```



## TODO
- Automate it with Terraform / Ansible


