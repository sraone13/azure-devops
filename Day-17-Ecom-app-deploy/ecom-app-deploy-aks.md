# 🚀 Day 17 – Deploy E-commerce Application on AKS

## 📌 Overview

In this exercise, we deploy a three-tier e-commerce application on **Azure Kubernetes Service (AKS)** using Helm charts and expose it via Ingress.

---

## 🧱 Step 1: Create AKS Cluster

* Go to Azure Portal
* Create an AKS Cluster
* Note down:

  * Cluster Name
  * Resource Group
  * Region

---

## 📥 Step 2: Clone the Repository

```bash
# Create a local folder and navigate into it
cd <your-folder>

# Clone the repository
git clone https://github.com/iam-veeramalla/three-tier-architecture-demo

# Navigate into project
cd three-tier-architecture-demo
```

---

## 🔗 Step 3: Connect to AKS Cluster

```bash
# Login to Azure
az login

# Get AKS credentials
az aks get-credentials --name three-tireapp --resource-group azureapp-ecom --overwrite-existing
```

### ✅ Verify Connection

```bash
kubectl get pods
kubectl config current-context
```

---

## 📂 Step 4: Navigate to Helm Chart

```bash
cd AKS
ls
cd helm
ls
```

---

## 📦 Step 5: Deploy Application using Helm

```bash
# Create namespace
kubectl create ns robot-shop

# Install Helm chart
helm install robot-shop --namespace robot-shop .
```

### ✅ Verify Pods

```bash
kubectl get pods -n robot-shop
```

---

## 💾 Step 6: Understand Storage (PVC & StorageClass)

```bash
kubectl get storageclass
kubectl get pods -n robot-shop
```

### 🔍 Inspect Redis Pod

```bash
kubectl describe pod redis-0 -n robot-shop
kubectl get pvc -n robot-shop
```

### 📌 Notes:

* Default storage class uses **Azure Disk**
* **Azure Disk** → Single pod access (ReadWriteOnce)
* **Azure Files** → Multiple pod access (ReadWriteMany)

---

## 🌐 Step 7: Check Services

```bash
kubectl get svc -n robot-shop
```

---

## 🚪 Step 8: Enable Ingress Controller

* Go to AKS Cluster in Azure Portal
* Navigate to **Networking**
* Enable **Ingress Controller**
* Apply changes

---

## 📝 Step 9: Create Ingress Resource

Create a file:

```bash
notepad ingress.yaml
```

### 📄 ingress.yaml

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  namespace: robot-shop
  name: robot-shop
spec:
  ingressClassName: azure-application-gateway
  rules:
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web
                port:
                  number: 8080
```

---

## 🚀 Step 10: Apply Ingress

```bash
kubectl apply -f ingress.yaml -n robot-shop
```

---

## 🔍 Step 11: Verify Ingress

```bash
kubectl get ing -n robot-shop
kubectl get pods -n kube-system
```

---

## 🛠️ Step 12: Troubleshooting (Optional)

```bash
kubectl edit deploy <ingress-deployment-name> -n kube-system
kubectl logs <ingress-pod-name> -n kube-system
```

---

## ✅ Final Verification

* All pods should be in **Running** state
* Ingress should be created successfully
* Access application via external IP / DNS

---

## 🎯 Summary

* Created AKS cluster
* Deployed app using Helm
* Verified storage (PVC, StorageClass)
* Exposed application using Ingress

---

## 💡 Notes

* Ensure Azure quota limits (Public IP) are sufficient
* AGIC requires proper permissions and configuration
* For quick testing, LoadBalancer or port-forward can be used

---
