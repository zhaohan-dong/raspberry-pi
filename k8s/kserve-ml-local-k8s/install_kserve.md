# Installing KServe without Kubeflow
[Deployment Guide](https://kserve.github.io/website/0.7/admin/kubernetes_deployment/#2-install-cert-manager)
KServe requires the following components:
- Istio
- Knative (Optional with RawDeployment, required for Serverless deployment)
- Cert Manager
- KServe

## 1. Install Istio
[Istio Helm installation guide](https://istio.io/latest/docs/setup/install/helm/)
### 1.1 Install Istio base chart in `istio-system` namespace
[Helm repository](https://artifacthub.io/packages/helm/istio-official/base)
```
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
```
`helm install istio-base istio/base -n istio-system --create-namespace`
### 1.2 Install istio discovery chart with `istiod` service in `istio-system` namespace
`helm install istiod istio/istiod -n istio-system --wait`

## 2. Install cert-manager
### 2.1 Install the Helm chart
[Cert-manager Helm installation guide](https://cert-manager.io/docs/installation/helm/)
[Helm repository](https://artifacthub.io/packages/helm/cert-manager/cert-manager)
**Note: Install cert-manager CRD separately, as described in the Helm repository, not the guide.**
`kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.2/cert-manager.crds.yaml`
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
```
```
helm install \
  cert-manager jetstack/cert-manager \
  --namespace kserve \
  --create-namespace \
  --version v1.12.2 \
  --set installCRDs=true
```
### 2.2 Set self-signed issuer
**Issue: Installing self-signed issuer after helm update would result in error "the server could not find the requested resource (post clusterissuers.cert-manager.io)"**
```
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: selfsigned-issuer
  namespace: kserve
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-cluster-issuer
  namespace: kserve
spec:
  selfSigned: {}
EOF
```

## 3. Install KServe
`wget https://github.com/kserve/kserve/releases/download/v0.7.0/kserve.yaml`
(RawDeployment mode)Open the kserve.yaml, find the `ConfigMap` with name `inferenceservice-config` in the manifest and modify the `deploy` section:<br/>
Line 12326<br/>
```
deploy:
    {
      "defaultDeploymentMode": "RawDeployment"
    }
```
Also change (Otherwise it will give "resource mapping not found for name" error and propmt to install CRDs):<br/>
```
apiVersion: cert-manager.io/v1
kind: Certificate
```
and<br/>
```
apiVersion: cert-manager.io/v1
kind: Issuer
```
to<br/>
```
apiVersion: cert-manager.io/v1
kind: Certificate

apiVersion: cert-manager.io/v1
kind: Issuer
```

Then:<br/>

`kubectl apply -f kserve.yaml`