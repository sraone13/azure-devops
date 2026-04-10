# 🚀 AKS + Azure Key Vault Integration (Workload Identity)

## 📅 Day 20 Notes

---

## 1️⃣ AKS Setup using CLI

### 🔹 Create Resource Group

```bash
az group create --name sravan-keyvault-demo1 --location centralindia
```

### 🔹 Create AKS Cluster with Key Vault Integration

```bash
az aks create \
  --name sravan-keyvault-demo-cluster \
  --resource-group sravan-keyvault-demo1 \
  --node-count 1 \
  --enable-addons azure-keyvault-secrets-provider \
  --enable-oidc-issuer \
  --enable-workload-identity
```

---

## 2️⃣ Connect to AKS Cluster

```bash
az aks get-credentials \
  --resource-group sravan-keyvault-demo1 \
  --name sravan-keyvault-demo-cluster
```

### ✅ Verify Context

```bash
kubectl config current-context
```

---

## 3️⃣ Verify CSI Driver Installation

```bash
kubectl get pods -n kube-system \
  -l 'app in (secrets-store-csi-driver,secrets-store-provider-azure)' -o wide
```

---

## 4️⃣ Azure Key Vault Setup

### 🔹 Create Key Vault (RBAC Enabled)

```bash
az keyvault create \
  -n aks-demo-sravan \
  -g sravan-keyvault-demo1 \
  -l centralindia \
  --enable-rbac-authorization
```

### ⚠️ If Provider Not Registered

```bash
az provider register --namespace Microsoft.KeyVault
az provider show --namespace Microsoft.KeyVault --query "registrationState"
```

Expected Output:

```
Registered
```

### 🔹 Assign Role (UI Recommended)

* Go to **Access Control (IAM)**
* Add Role: **Key Vault Administrator**
* Assign to your user

---

## 5️⃣ Configure Workload Identity

### 🔹 Export Variables

```bash
export SUBSCRIPTION_ID=<your-subscription-id>
export RESOURCE_GROUP=sravan-keyvault-demo1
export UAMI=azurekeyvaultsecretsprovider-sravan-keyvault-demo-cluster
export KEYVAULT_NAME=aks-demo-sravan
export CLUSTER_NAME=sravan-keyvault-demo-cluster
```

```bash
az account set --subscription $SUBSCRIPTION_ID
```

---

### 🔹 Create Managed Identity

```bash
az identity create --name $UAMI --resource-group $RESOURCE_GROUP
```

```bash
export USER_ASSIGNED_CLIENT_ID=$(az identity show \
  -g $RESOURCE_GROUP \
  --name $UAMI \
  --query 'clientId' -o tsv)

export IDENTITY_TENANT=$(az aks show \
  --name $CLUSTER_NAME \
  --resource-group $RESOURCE_GROUP \
  --query identity.tenantId -o tsv)
```

---

### 🔹 Assign Role to Managed Identity

```bash
export KEYVAULT_SCOPE=$(az keyvault show --name $KEYVAULT_NAME --query id -o tsv)

az role assignment create \
  --role "Key Vault Administrator" \
  --assignee $USER_ASSIGNED_CLIENT_ID \
  --scope $KEYVAULT_SCOPE
```

---

### 🔹 Get OIDC Issuer URL

```bash
export AKS_OIDC_ISSUER=$(az aks show \
  --resource-group $RESOURCE_GROUP \
  --name $CLUSTER_NAME \
  --query "oidcIssuerProfile.issuerUrl" -o tsv)

echo $AKS_OIDC_ISSUER
```

---

## 6️⃣ Create Kubernetes Service Account

```bash
export SERVICE_ACCOUNT_NAME="workload-identity-sa"
export SERVICE_ACCOUNT_NAMESPACE="default"
```

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    azure.workload.identity/client-id: ${USER_ASSIGNED_CLIENT_ID}
  name: ${SERVICE_ACCOUNT_NAME}
  namespace: ${SERVICE_ACCOUNT_NAMESPACE}
EOF
```

### ✅ Verify

```bash
kubectl get sa
```

---

## 7️⃣ Setup Federation

```bash
export FEDERATED_IDENTITY_NAME="aksfederatedidentity"
```

```bash
az identity federated-credential create \
  --name $FEDERATED_IDENTITY_NAME \
  --identity-name $UAMI \
  --resource-group $RESOURCE_GROUP \
  --issuer ${AKS_OIDC_ISSUER} \
  --subject system:serviceaccount:${SERVICE_ACCOUNT_NAMESPACE}:${SERVICE_ACCOUNT_NAME}
```

---

## 8️⃣ Create SecretProviderClass

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azure-kvname-wi
spec:
  provider: azure
  parameters:
    usePodIdentity: "false"
    clientID: "${USER_ASSIGNED_CLIENT_ID}"
    keyvaultName: ${KEYVAULT_NAME}
    objects: |
      array:
        - |
          objectName: sravan123
          objectType: secret
        - |
          objectName: sravan1
          objectType: key
    tenantId: "${IDENTITY_TENANT}"
```

---

## 9️⃣ Deploy Sample Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-secrets-store-inline-wi
  labels:
    azure.workload.identity/use: "true"
spec:
  serviceAccountName: workload-identity-sa
  containers:
  - name: busybox
    image: registry.k8s.io/e2e-test-images/busybox:1.29-4
    command: ["/bin/sleep", "10000"]
    volumeMounts:
    - name: secrets-store01-inline
      mountPath: "/mnt/secrets-store"
      readOnly: true
  volumes:
  - name: secrets-store01-inline
    csi:
      driver: secrets-store.csi.k8s.io
      readOnly: true
      volumeAttributes:
        secretProviderClass: azure-kvname-wi
```

---

## 🔟 Verification

### 🔹 Check Pods

```bash
kubectl get pods
```

### 🔹 List Mounted Secrets

```bash
kubectl exec busybox-secrets-store-inline-wi -- ls /mnt/secrets-store/
```

### 🔹 Read Secret

```bash
kubectl exec busybox-secrets-store-inline-wi -- \
  sh -c "cat /mnt/secrets-store/sravan123"
```

---

## ✅ Key Takeaway

* Secrets are fetched **directly from Azure Key Vault**
* No need to manually update Kubernetes secrets
* **Automatic rotation supported** 🎯

---

## 📌 Summary Flow

```
AKS Pod → Service Account → Workload Identity → Managed Identity → Key Vault
```

---
