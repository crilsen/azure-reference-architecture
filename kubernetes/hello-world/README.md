# Hello World on AKS with a Standard Load Balancer

The application is published through the Azure Standard Load Balancer that AKS
manages, using a Kubernetes `Service` of type `LoadBalancer` and a static public
IP reserved by Terraform:

```text
Internet -> static public IP -> AKS Standard Load Balancer -> Service -> Pod
```

The `Service` is `LoadBalancer` (layer 4/TCP). AKS provisions the load balancer
in the cluster node resource group and attaches the static public IP created in
`environments/lab`.

## 1. Reserve infrastructure and the public IP

Apply Terraform first, then read the values the manifests need:

```bash
cd environments/lab
terraform init
terraform apply -var-file=terraform.tfvars

terraform output -raw lb_public_ip
terraform output -raw lb_resource_group
terraform output -raw workload_identity_client_id
cd ../..
```

In `hello-world.yaml`, replace:

- `service.beta.kubernetes.io/azure-load-balancer-ipv4` with `lb_public_ip`.
- `service.beta.kubernetes.io/azure-load-balancer-resource-group` with
  `lb_resource_group` (defaults to `rg-kubernetes-lab`).
- `azure.workload.identity/client-id` on the `ServiceAccount` with
  `workload_identity_client_id`.

Remove the `azure-dns-label-name` annotation if you do not want the generated
`cloudapp.azure.com` name, or set it to a label that is unique in the region.

## 2. Connect to the cluster

```bash
az aks get-credentials --resource-group rg-kubernetes-lab --name aks-kubernetes-lab
kubectl get nodes
```

## 3. Deploy

```bash
kubectl apply -f kubernetes/base/namespace.yaml
kubectl apply -f kubernetes/hello-world/hello-world.yaml
kubectl rollout status deployment/hello-world -n lab-workloads
kubectl get pods,service,serviceaccount -n lab-workloads
```

Wait until the `Service` shows the static IP in `EXTERNAL-IP`:

```bash
kubectl get service hello-world -n lab-workloads --watch
```

Then test:

```bash
curl "http://<lb_public_ip>"
curl "http://<lb_public_ip>/healthz"
```

## Remove

Delete the `Service` before destroying Terraform so AKS releases the load
balancer frontend that references the static IP:

```bash
kubectl delete -f kubernetes/hello-world/hello-world.yaml
terraform -chdir=environments/lab destroy -var-file=terraform.tfvars
```

The Standard Load Balancer, public IP, AKS nodes, Container Registry, and Log
Analytics workspace generate charges while they exist.
