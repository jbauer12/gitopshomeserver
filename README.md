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
RC1ztRewNMQyveY1%
G8hiyRZH7mLv5G0B
## TODO
- Automate it with Terraform / Ansible


RC1ztRewNMQyveY1%