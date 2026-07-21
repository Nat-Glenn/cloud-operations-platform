# Monitoring bootstrap for cloud-operations-platform
#
# Installs kube-prometheus-stack with lightweight values sized for the
# 2x t3.small EKS nodes (11 pods/node). Default chart installs fail with
# FailedScheduling: Too many pods.
#
# Prerequisites:
# - kubectl context on cloud-operations-platform-dev-eks-cluster
# - Enough free pod slots (slim Argo CD + ALB replica=1; see below)

## Capacity notes

Each `t3.small` allocates **11 pods**. Full Argo CD + dual ALB + app replicas
fills the cluster before Grafana/Prometheus can schedule. This repo's Argo
values disable Dex/ApplicationSet/Notifications to free slots.


## Lab capacity tradeoffs

On this 2x `t3.small` cluster (11 pods/node), free one pod slot by running the
AWS Load Balancer Controller at **replicaCount=1** (temporary lab tradeoff —
removes controller HA). Preserve existing Helm settings (`clusterName`,
`serviceAccount`, `region`, `vpcId`) and only change replicas:

```bash
helm upgrade aws-load-balancer-controller eks/aws-load-balancer-controller \
  --namespace kube-system \
  --reuse-values \
  --set replicaCount=1 \
  --wait
```

Install command uses `platform/monitoring/values.yaml`.

Also applied on this lab cluster (not HA):
- Argo CD: Dex/Notifications disabled; ApplicationSet `replicas: 0`
- CoreDNS scaled to **1** replica so Prometheus can schedule
- Alertmanager **disabled** in `values.yaml` (insufficient pod slots)
- Prometheus uses ephemeral emptyDir storage (no EBS PVC)


## Install / upgrade

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# If a previous default install failed:
helm uninstall kube-prometheus-stack -n monitoring || true
kubectl delete pvc -n monitoring --all || true

helm upgrade --install kube-prometheus-stack \
  prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --values platform/monitoring/values.yaml \
  --timeout 15m \
  --wait
```

## Access

```bash
# Grafana (admin / prom-operator)
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80

# Prometheus
kubectl -n monitoring port-forward svc/kube-prometheus-stack-prometheus 9090:9090

# Alertmanager is disabled on this lab cluster (see values.yaml).
```
