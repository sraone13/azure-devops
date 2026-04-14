# 🚀 Day 7 – Azure Networking with VM, Bastion & Firewall (DNAT)

## 📌 Overview

In this exercise, we learn Azure networking concepts by:

* Creating a Virtual Network (VNet)
* Deploying a VM in a private subnet
* Connecting via Bastion
* Hosting a web app using Nginx
* Exposing the app using Firewall DNAT rules

---

## 🧱 Step 1: Create Resource Group

* Go to Azure Portal
* Create a Resource Group
* Provide:

  * Name
  * Region

---

## 🌐 Step 2: Create Virtual Network (VNet)

* Create a VNet
* Define:

  * Address space (e.g., `10.0.0.0/16`)
  * Subnets (e.g., private subnet)

---

## 🖥️ Step 3: Create Virtual Machine

* Create a Linux VM (Ubuntu)
* In **Networking section**:

  * Select the VNet created
  * Select the **private subnet**
  * ❌ Do NOT assign Public IP

---

## 🔐 Step 4: Connect to VM using Bastion

👉 Since VM is in a private subnet, it has **no public IP**

Use Azure Bastion:

* Go to VM → Click **Connect → Bastion**
* Use SSH key to connect

---

## 🛠️ Step 5: Install Nginx on VM

```bash id="b2gqzw"
sudo su
apt-get update
apt-get install nginx -y
```

---

## ▶️ Step 6: Start Nginx

```bash id="2m2x8y"
sudo systemctl start nginx
```

---

## 📝 Step 7: Update Web Page

```bash id="1mf1k3"
sudo vim /var/www/html/index.html
```

### 📄 Replace content with:

```html id="jqm1h3"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demo Page</title>
</head>
<body>
    <h1>I Learnt how networking works in Azure today</h1>
</body>
</html>
```

---

## 🔄 Step 8: Restart Nginx

```bash id="4a1y7h"
sudo systemctl restart nginx
```

---

## 🔥 Step 9: Configure Azure Firewall (DNAT)

To access the application externally, configure **DNAT rule** in Azure Firewall.

---

### 🔹 Steps:

1. Go to **Azure Firewall**
2. Click **Firewall Policy**
3. Navigate to:

   * **DNAT Rules**
4. Click **Add Rule Collection**

---

### 🔹 Configure DNAT Rule

Fill the following details:

* **Source IP** → Your laptop public IP
* **Destination IP** → Firewall Public IP
* **Destination Port** → `4000`
* **Translated IP** → VM Private IP
* **Translated Port** → `80`

👉 Save the rule

---

## 🌐 Step 10: Access Application

* Copy Firewall Public IP
* Open browser:

```bash id="f8qlp5"
http://<firewall-public-ip>:4000
```

👉 You should see your Nginx web page 🎉

---

## ✅ Summary

* Created Resource Group and VNet
* Deployed VM in private subnet
* Connected using Bastion
* Installed and configured Nginx
* Exposed app using Firewall DNAT

---

## 💡 Key Learnings

* Private VMs cannot be accessed directly via internet
* Bastion provides secure access without public IP
* Azure Firewall DNAT enables external access to private resources
* Port translation maps external requests to internal services

---
