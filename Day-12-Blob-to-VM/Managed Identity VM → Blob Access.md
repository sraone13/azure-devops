# 🚀 Day 12 – Azure IAM (Microsoft Entra ID) & Managed Identity (VM → Blob Access)

## 📌 Overview

In this exercise, we explore **Microsoft Entra ID (IAM)** and implement a **resource-to-resource access** scenario.

### 🎯 Use Case:

Access a file stored in **Blob Storage** from a **Virtual Machine** using **Managed Identity** (without storing credentials).

---

## 🧱 Architecture

* VM (with Managed Identity enabled)
* Storage Account (Blob container with file)
* IAM Role Assignment (VM → Storage)

---

## 🪜 Step-by-Step Implementation

---

## 🔹 Step 1: Create Resource Group

* Go to Azure Portal
* Create a Resource Group

---

## 🔹 Step 2: Create Storage Account & Blob

1. Create a **Storage Account**
2. Go to:

   * **Containers**
3. Create a container (e.g., `test`)
4. Upload a sample HTML file:

   * Example: `signin.html`

---

## 🔹 Step 3: Create Virtual Machine

* Create a Linux VM
* Use:

  * Username & Password authentication

---

## 🔹 Step 4: Enable Managed Identity on VM

* Go to VM → **Security → Identity**
* Enable **System Assigned Managed Identity**
* Click **Save**

---

## 🔹 Step 5: Assign IAM Role to VM

Go to Storage Account:

1. Click **Access Control (IAM)**
2. Click **Add → Add Role Assignment**
3. Select Role:

   * **Storage Blob Data Owner** (or Reader for read-only)
4. Click **Next**
5. Select:

   * **Managed Identity**
6. Click **Select Members**
7. Choose your VM
8. Click **Create**

---

## 🔑 Step 6: Login to VM

```bash id="q2l3w9"
ssh azureuser@<vm-public-ip>
```

Enter password when prompted.

---

## ⚙️ Step 7: Install Required Tools

```bash id="8k9d2c"
sudo apt update
sudo apt install jq -y
```

---

## 🔐 Step 8: Fetch Access Token (Managed Identity)

```bash id="v8y3pl"
access_token=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fstorage.azure.com%2F' -H Metadata:true | jq -r '.access_token')
```

---

## 📂 Step 9: Access Blob File

```bash id="z4r9kx"
curl "https://<storage-account-name>.blob.core.windows.net/<container-name>/<file-name>" \
  -H "x-ms-version: 2017-11-09" \
  -H "Authorization: Bearer $access_token"
```

### 📌 Example:

```bash id="k1m7qw"
curl "https://projectiamsa.blob.core.windows.net/test/signin.html" \
  -H "x-ms-version: 2017-11-09" \
  -H "Authorization: Bearer $access_token"
```

---

## ✅ Expected Output

* HTML file content will be displayed in terminal
* This confirms secure access via Managed Identity 🎉

---

## 🎯 Summary

* Used IAM via Microsoft Entra ID
* Enabled Managed Identity on VM
* Assigned RBAC role to access Storage
* Generated access token
* Accessed Blob file securely without credentials

---

## 💡 Key Learnings

* Managed Identity removes need for secrets/passwords
* IAM controls resource-level access securely
* RBAC roles define permissions between resources
* Azure metadata endpoint (`169.254.169.254`) is used to fetch tokens

---

## 🔐 Best Practice

* Use **Storage Blob Data Reader** for least privilege
* Avoid using Owner role in production
* Always follow **principle of least privilege**

---
