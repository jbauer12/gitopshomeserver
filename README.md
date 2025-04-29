## First Steps
- Install ArgoCD 

```bash
kubectl create namespace argocd

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm install argocd argo/argo-cd -n argocd \
  --set server.service.type=LoadBalancer
```
## TODO
- Automate it with Terraform / Ansible