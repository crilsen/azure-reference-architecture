# Azure: Management Groups, Policy, AKS, and Load Balancer

Azure uses an existing Microsoft Entra tenant and governance subscription. Terraform associates existing Lab and Production subscriptions; subscription purchase and billing enrollment remain external.

## Hierarchy

```text
Microsoft Entra tenant
├── Governance subscription (execution context)
└── Kubernetes Lab Workloads management group
    ├── Lab subscription
    └── Production subscription
```

`modules/management-groups` creates the Management Group and associations. `modules/policy` defines and assigns an allowed-locations policy inherited by both subscriptions. Azure Policy is conceptually comparable to an SCP for deny controls, but has different evaluation and effects; it never grants RBAC access.

The governance root runs against the tenant-level context:

```bash
cd environments/organization
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

Replace tenant/subscription placeholders privately. The caller needs tenant-level Management Group and policy permissions. Moving subscriptions changes inherited governance, and policy propagation is asynchronous.

## AKS workload boundary

`environments/lab` is an independent root with its own state. It composes provider-native modules and exposes a Kubernetes API server through a controlled ingress path:

| Module | Purpose |
| --- | --- |
| `modules/network` | Virtual Network and AKS node subnet |
| `modules/aks` | AKS cluster (Azure CNI Overlay, OIDC, Workload Identity, Azure RBAC) |
| `modules/acr` | Azure Container Registry with AcrPull for the kubelet identity |
| `modules/monitor` | Log Analytics workspace for Container Insights |
| `modules/workload-identity` | User-assigned managed identity with a federated credential |

### Load balancer

`environments/lab` reserves a static Standard public IP and grants the AKS cluster identity Network Contributor on its resource group. A Kubernetes `Service` of type `LoadBalancer` references that IP through annotations, so the address survives service redeploys:

```text
Internet -> static public IP -> AKS Standard Load Balancer -> Service -> Pod
```

The Azure Load Balancer operates at layer 4 (TCP). The `kubernetes/hello-world` manifest demonstrates the static IP annotation, Workload Identity on a service account, and a hardened nginx deployment.

```bash
cd environments/lab
terraform init
terraform validate
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars

az aks get-credentials --resource-group rg-kubernetes-lab --name aks-kubernetes-lab
kubectl apply -f kubernetes/base/namespace.yaml
kubectl apply -f kubernetes/hello-world/hello-world.yaml
```

Run organization and workload roots with different state. Review subscription scope, Azure Policy impact, quotas, and cost before applying. The load balancer, public IP, node pools, registry, and Log Analytics workspace generate charges while they exist.
