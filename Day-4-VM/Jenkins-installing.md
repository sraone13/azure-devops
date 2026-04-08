# 🚀 Day 4 – Deploy Jenkins on Azure VM

## 📌 Overview

In this exercise, we deploy **Jenkins on an Azure Virtual Machine and access it via browser.

---

## 🖥️ Step 1: Create Virtual Machine

* Go to Azure Portal
* Create a Linux VM (Ubuntu recommended)
* Ensure:

  * Public IP is enabled
  * SSH key pair is downloaded (`.pem` file)

---

## 🔐 Step 2: Connect to VM (Git Bash)

```bash
# Set permission for key
chmod 600 jenkins12_key.pem

# Connect to VM using SSH
ssh -i jenkins12_key.pem azureuser@<public-ip>
```

---

## 📦 Step 3: Install Java (Required for Jenkins)

```bash
sudo apt-get update
sudo apt install openjdk-21-jdk -y
```

### ✅ Verify Java Installation

```bash
java --version
```

---

## 📥 Step 4: Add Jenkins Repository

```bash
curl -fsSL https://pkg.origin.jenkins.io/debian-stable/jenkins.io-2026.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.origin.jenkins.io/debian-stable/ binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
```

---

## ⚙️ Step 5: Install Jenkins

```bash
sudo apt update
sudo apt install jenkins -y
```

---

## ▶️ Step 6: Start Jenkins Service

```bash
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

### ✅ Verify Jenkins Process

```bash
ps -ef | grep jenkins
```

---

## 🌐 Step 7: Access Jenkins in Browser

Open browser and navigate:

```bash
http://<public-ip>:8080
```

---

## 🚫 If Jenkins is Not Accessible

👉 Port **8080** is not open by default.

### 🔧 Fix: Add Inbound Rule in Azure

1. Go to VM in Azure Portal
2. Click **Networking**
3. Click **Add inbound port rule**
4. Configure:

   * Port: **8080**
   * Protocol: TCP
   * Action: Allow
5. Save changes

---

## 🔑 Step 8: Unlock Jenkins

Run this command on VM:

```bash
cat /var/lib/jenkins/secrets/initialAdminPassword
```

👉 Copy the password and paste it in Jenkins UI

---

## 🎯 Final Step

* Install suggested plugins
* Create admin user
* Start using Jenkins

---

## ✅ Summary

* Created Azure VM
* Installed Java & Jenkins
* Opened port 8080
* Accessed Jenkins UI
* Retrieved admin password

---

## 💡 Notes

* Ensure VM security group allows port 8080
* Jenkins runs as a service (`systemctl`)
* Always secure Jenkins with proper credentials

---


# References

### Azure Virtual Machine Series 
https://azure.microsoft.com/en-in/pricing/details/virtual-machines/series/

### Jenkins Installation Steps
https://github.com/iam-veeramalla/Jenkins-Zero-To-Hero

### Download Git Bash
https://git-scm.com/downloads
