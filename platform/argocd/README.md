# Argo CD bootstrap for cloud-operations-platform
#
# Installs Argo CD with Helm (separate from helm/cloud-operations) and registers
# an Application that syncs helm/cloud-operations from main into staging.
#
# Prerequisites:
# - kubectl context pointed at cloud-operations-platform-dev-eks-cluster
# - Helm 3.x installed locally
# - Staging namespace available (platform/namespaces/staging.yaml)

## 1. Install Argo CD (Helm)

```bash
kubectl apply -f platform/namespaces/staging.yaml

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --values platform/argocd/values.yaml \
  --wait
```

## 2. Register the cloud-operations Application

```bash
kubectl apply -f platform/argocd/applications/cloud-operations.yaml
```

If the GitHub repository is **private**, create a repo credential before the app can sync (PAT or deploy key). Example with a PAT stored in a Kubernetes secret:

```bash
# MANUAL: create a GitHub PAT (repo read) or deploy key, then:
kubectl -n argocd create secret generic repo-cloud-operations-platform \
  --from-literal=type=git \
  --from-literal=url=https://github.com/Nat-Glenn/cloud-operations-platform.git \
  --from-literal=password='YOUR_GITHUB_PAT' \
  --from-literal=username=git

kubectl -n argocd label secret repo-cloud-operations-platform \
  argocd.argoproj.io/secret-type=repository
```

Public repositories do not need this secret.

## 3. Verify

```bash
kubectl -n argocd get pods
kubectl -n argocd get applications.argoproj.io cloud-operations
kubectl -n argocd get application cloud-operations -o yaml | grep -A20 'status:'

# Optional CLI (after installing argocd CLI):
argocd app get cloud-operations
argocd app sync cloud-operations
```

Expect `Synced` / `Healthy` once images and the chart render successfully in `staging`.

```bash
kubectl -n staging get deploy,svc,ingress
```

## 4. Login (UI via port-forward)

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d; echo

kubectl -n argocd port-forward svc/argocd-server 8080:443
```

Open https://localhost:8080 — username `admin`, password from the secret above.

## 5. Manifest validation (local)

```bash
kubectl apply --dry-run=client -f platform/argocd/applications/cloud-operations.yaml
kubectl apply --dry-run=server -f platform/argocd/applications/cloud-operations.yaml
```

`server` dry-run requires a live cluster with the Argo CD CRDs installed.

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Application `Unknown` / `ComparisonError` | Repo private without credential; URL/path/revision typos |
| `UnsupportedMediaType` / CRD missing | Argo CD Helm install did not finish; re-run install with `--wait` |
| Sync OK but pods `ImagePullBackOff` | ECR pull permissions on nodes/IRSA; image tag exists in ECR |
| Sync stuck `OutOfSync` | `kubectl -n argocd describe application cloud-operations`; check syncPolicy and prune |
| Cannot log in | Reset admin: delete `argocd-initial-admin-secret` and restart `argocd-server`, or use `argocd account update-password` |
| Wrong cluster context | `kubectl config current-context` and `aws eks update-kubeconfig --region ca-central-1 --name cloud-operations-platform-dev-eks-cluster` |

## Layout

| Path | Purpose |
| --- | --- |
| `platform/argocd/values.yaml` | Helm values for the upstream `argo/argo-cd` chart |
| `platform/argocd/applications/cloud-operations.yaml` | Argo CD Application CR |
| `helm/cloud-operations` | Application chart watched by Argo CD (not used to install Argo CD) |
