# 🚀 Day 15 – Continuous Deployment (CD) using ArgoCD on AKS

## 📌 Overview

In this project, we implement **Continuous Deployment (CD)** using:

* Azure Kubernetes Service
* Argo CD
* Azure DevOps

👉 Goal: Automatically deploy applications to Kubernetes when code changes.

---

# 🧱 Step 1: Create AKS Cluster

* Go to Azure Portal → Create AKS

### 🔹 Basic Settings

* Cluster Name
* Availability Zone: Zone 1

### 🔹 Node Pool Configuration

* Min Nodes: 1
* Max Nodes: 2
* Max Pods per node: 30
* Enable Public IP per node

👉 Review and Create AKS Cluster

---

# 🔗 Step 2: Connect to AKS Cluster

```bash
az login
az aks get-credentials --name votingcicd --resource-group azurecicd --overwrite-existing
kubectl get pods
```

---

# 📦 Step 3: Install ArgoCD

```bash
kubectl create namespace argocd

kubectl apply -n argocd --server-side --force-conflicts \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### ✅ Verify Installation

```bash
kubectl get pods -n argocd
```

---

# 🔐 Step 4: Configure ArgoCD Access

## 🔹 Get Admin Password

```bash
kubectl get secrets -n argocd
kubectl edit secret argocd-initial-admin-secret -n argocd
```

👉 Decode Base64 password:

```bash
echo <base64-password> | base64 --decode
```

* Username: `admin`
* Password: decoded value

---

## 🔹 Expose ArgoCD (NodePort)

```bash
kubectl get svc -n argocd
kubectl edit svc argocd-server -n argocd
```

👉 Change:

```yaml
type: NodePort
```

---

## 🔹 Get Access URL

```bash
kubectl get svc -n argocd
kubectl get nodes -o wide
```

👉 Open:

```
http://<node-ip>:<nodeport>
```

---

## ⚠️ If Not Accessible

* Go to **VMSS → Networking**
* Add inbound rule for NodePort

---

# 🔗 Step 5: Connect ArgoCD with Azure Repo

1. Generate PAT Token in Azure DevOps
2. Go to ArgoCD → Settings → Repositories
3. Add repository:

   * Method: HTTPS
   * Paste repo URL
   * Replace password with PAT token

---

# 📦 Step 6: Create ArgoCD Application

* App Name: `votapp-service`
* Project: Default
* Sync Policy: Automatic
* Repo URL: Auto
* Path: `k8s-specifications`
* Namespace: Default

👉 Click **Create**

---

# 🔄 Step 7: Create Deployment Update Script

Create file:

```bash
scripts/updateK8sManifests.sh
```

```bash
#!/bin/bash

sed -i 's/\r$//' "$0"

set -e
set -x

REPO_URL="<your-repo-url>"

git clone "$REPO_URL" /tmp/temp_repo
cd /tmp/temp_repo

FILE="k8s-specifications/$1-deployment.yaml"

sed -i "s|image: .*|image: <acr-name>.azurecr.io/$2:$3|g" "$FILE"

git config user.email "pipeline@local.com"
git config user.name "azure-pipeline"

git add .

if git diff --cached --quiet; then
  echo "No changes"
else
  git commit -m "Update Kubernetes manifest"
  git push
fi

rm -rf /tmp/temp_repo
```

---

# 🔁 Step 8: Update Azure Pipeline

Add new stage in `vote.yml`:

```yaml
- stage: Update
  jobs:
  - job: Update
    steps:
    - task: ShellScript@2
      inputs:
        scriptPath: scripts/updateK8sManifests.sh
        args: vote $(imageRepository) $(tag)
```

---

# ⚠️ Step 9: Fix Image Pull Issue (ACR Private)

👉 Pods may fail due to private ACR

## 🔹 Enable Admin Access in ACR

* Go to ACR → Access Keys → Enable Admin

---

## 🔹 Create Kubernetes Secret

```bash
kubectl create secret docker-registry acr-secret \
--namespace default \
--docker-server=<acr-name>.azurecr.io \
--docker-username=<username> \
--docker-password=<password>
```

---

## 🔹 Update Deployment YAML

```yaml
imagePullSecrets:
- name: acr-secret
```

👉 Commit changes

---

# 🔍 Step 10: Verification

Check everything:

```bash
kubectl get pods
kubectl get svc
kubectl get nodes -o wide
```

---

## 🌐 Access Application

* Copy Node External IP
* Get service port

```
http://<external-ip>:<port>
```

---

# 🔄 Final Test

👉 Make changes in app (e.g., vote options)

Verify:

* CI Pipeline runs
* CD via ArgoCD triggers
* Pods update
* App reflects changes

---

# ✅ Summary

* Created AKS cluster
* Installed ArgoCD
* Connected repo
* Implemented GitOps CD
* Automated deployment updates
* Resolved ACR authentication issues

---

# 💡 Key Learnings

* ArgoCD enables GitOps-based deployment
* CI updates image → CD deploys automatically
* Kubernetes secrets secure private registry access
* End-to-end CI/CD pipeline improves automation

---
