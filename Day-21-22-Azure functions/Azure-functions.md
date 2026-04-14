# 🚀 Day - 22: Azure Functions (Event-Driven Serverless with Blob Trigger)

## 📌 Overview

In this lab, we implemented a **serverless architecture** using Azure Functions with a **Blob Trigger**.

👉 Whenever a file is uploaded to Azure Blob Storage, the function is automatically triggered.

---

## 🧠 Key Concepts

* **Azure Functions** → Serverless compute service
* **Event-driven architecture** → Executes code based on events
* **Blob Trigger** → Runs function when a blob is created/updated
* **Consumption Plan** → Pay only when function runs

---

## 📌 Step 1: Create Function App using Azure CLI Script

### 🔧 Open Git Bash and login:

```bash
az login
```

---

### 📝 Create Script File

```bash
vim create-function-app.sh
```

Paste the below script:

```bash
# Function app and storage account names must be unique.

# Variable block
let "randomIdentifier=$RANDOM*$RANDOM"
location="centralindia"
resourceGroup="sravan123-azure-functions-rg-$randomIdentifier"
tag="create-function-app-consumption-python"
storage="sravan123$randomIdentifier"
functionApp="sravan123-serverless-python-function-$randomIdentifier"
skuStorage="Standard_LRS"
functionsVersion="4"
pythonVersion="3.9"

# Create a resource group
echo "Creating $resourceGroup in $location..."
az group create --name $resourceGroup --location "$location" --tags $tag

# Create an Azure storage account
echo "Creating storage account $storage"
az storage account create \
  --name $storage \
  --location "$location" \
  --resource-group $resourceGroup \
  --sku $skuStorage

# Create a serverless Python function app
echo "Creating function app $functionApp"
az functionapp create \
  --name $functionApp \
  --storage-account $storage \
  --consumption-plan-location "$location" \
  --resource-group $resourceGroup \
  --os-type Linux \
  --runtime python \
  --runtime-version $pythonVersion \
  --functions-version $functionsVersion
```

---

### 🔐 Give Permission & Execute Script

```bash
chmod 777 create-function-app.sh
./create-function-app.sh
```

---

## ✅ Resources Created

* Resource Group
* Storage Account
* Azure Function App (Python - Consumption Plan)

---

## 📌 Step 2: Create Azure Function (Blob Trigger)

1. Go to **Azure Portal**
2. Open the created **Function App**
3. Click on **Functions → Create**
4. Select:

   * Template: **Blob Trigger**
5. Configure:

   * Storage account connection
   * Container name

---

## ⚙️ How Blob Trigger Works

* Upload a file to Blob Storage
* Event is generated
* Azure Function executes automatically
* You can process/log/transform the file

---

## 🧪 Demo Flow

1. Upload a file to Blob Storage
2. Function gets triggered
3. Check logs in Function App

---

## 📂 Example Use Cases

* File processing pipelines
* Image/video processing
* Data ingestion workflows
* Automation tasks

---

## ⚠️ Important Notes

* Function app names must be **globally unique**
* Storage account is mandatory for Functions
* Blob trigger requires proper container setup
* Use supported Python version (3.7–3.9)

---

## 🎯 Summary

* Created Azure Function App using CLI
* Implemented serverless architecture
* Used Blob Trigger for event-driven execution
* Tested automatic execution on file upload

---

🔥 This is a real-world example of **event-driven serverless architecture using Azure**
