# 🚀 Day 14 – CI/CD Project (Voting App using Azure DevOps)

## 📌 Overview

In this project, we implement a **CI/CD pipeline** for a voting application using:

* Azure DevOps
* Docker
* Azure Container Registry

---

## 🔗 Project Repository

GitHub Repo:
https://github.com/dockersamples/example-voting-app 

---

# 🧱 Step 1: Create Azure DevOps Project

1. Go to Azure DevOps
2. Create a new project → **Voting App**

---

# 📥 Step 2: Import GitHub Repository

1. Go to **Repos**
2. Click **Import Repository**
3. Select:

   * Source: Git
   * Paste GitHub URL
4. Click **Import**

---

# 🌿 Step 3: Set Default Branch

1. Go to **Branches**
2. Click **3 dots** on `main` branch
3. Select **Set as default branch**

---

# ☁️ Step 4: Create Azure Resources

* Create **Resource Group**
* Create **Azure Container Registry (ACR)**

---

# 🔄 Step 5: Create CI Pipeline

1. Go to **Pipelines → Create Pipeline**
2. Select:

   * Azure Repos Git
   * Select repository
3. Choose **Docker template (Build & Push to ACR)**
4. Select:

   * Free Trial
   * Your ACR
5. Click **Validate & Configure**

---

# 📝 Step 6: Update Pipeline YAML (result.yml)

```yaml id="res-pipeline"
trigger:
  paths:
    include:
      - result/*

resources:
- repo: self

variables:
  dockerRegistryServiceConnection: 'd1a31a0c-14da-4038-a2ad-2b2992972b1f'
  imageRepository: 'resultapp'
  containerRegistry: 'votingregistry.azurecr.io'
  dockerfilePath: '$(Build.SourcesDirectory)/result/Dockerfile'
  tag: '$(Build.BuildId)'

pool:
  name: 'azureagent'

stages:
- stage: Build
  jobs:
  - job: Build
    steps:
    - task: Docker@2
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'build'
        Dockerfile: 'result/Dockerfile'
        tags: '$(tag)'

- stage: Push
  jobs:
  - job: Push
    steps:
    - task: Docker@2
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'push'
        tags: '$(tag)'
```

---

# 🖥️ Step 7: Create Self-Hosted Agent VM

* Create a Linux VM (Ubuntu)

---

# ⚙️ Step 8: Configure Agent Pool

1. Go to **Project Settings → Agent Pools**
2. Click **Add Pool**
3. Select:

   * Self-hosted
   * Name: `azureagent`
4. Enable access → Create

---

# 🔗 Step 9: Add Agent to VM

1. Open Agent Pool → Click **Agents → Add Agent**
2. Select **Linux**
3. Copy commands

---

## 🔐 Connect to VM

```bash id="vm-connect"
ssh azureuser@<vm-ip>
```

---

## 📦 Install & Configure Agent

```bash id="agent-setup"
sudo apt update

mkdir myagent && cd myagent
wget https://download.agent.dev.azure.com/agent/4.270.0/vsts-agent-linux-x64-4.270.0.tar.gz
tar zxvf vsts-agent-linux-x64-4.270.0.tar.gz
```

---

## ▶️ Configure Agent

```bash id="config-agent"
./config.sh
```

Provide:

* Server URL → https://dev.azure.com/sravanpeddapally
* PAT Token (create from Azure DevOps)
* Agent Pool → azureagent
* Agent Name → any

---

## ▶️ Start Agent

```bash id="run-agent"
./run.sh
```

---

# 🐳 Step 10: Install Docker on VM

```bash id="docker-install"
sudo apt install docker.io -y
sudo usermod -aG docker azureuser
sudo systemctl restart docker
```

---

# 🚀 Step 11: Run Pipeline

* Go to **Azure DevOps → Pipelines**
* Run pipeline
* If failure:

  * Logout & login again
  * Restart Docker
  * Restart agent

---

# 🔁 Step 12: Create Additional Pipelines

## vote.yml

```yaml id="vote-pipeline"
trigger:
  paths:
    include:
      - vote/*

variables:
  dockerRegistryServiceConnection: 'bbd636bc-61f9-4a2b-a134-f8a98cd1b4d5'
  imageRepository: 'votingapp'
  containerRegistry: 'votingregistry.azurecr.io'
  tag: '$(Build.BuildId)'

pool:
  name: 'azureagent'

stages:
- stage: Build
  jobs:
  - job: Build
    steps:
    - task: Docker@2
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'build'
        Dockerfile: 'voting/Dockerfile'
        tags: '$(tag)'

- stage: Push
  jobs:
  - job: Push
    steps:
    - task: Docker@2
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'push'
        tags: '$(tag)'
```

---

## worker.yml

```yaml id="worker-pipeline"
trigger:
  paths:
    include:
      - worker/*

variables:
  dockerRegistryServiceConnection: '5032091e-5c23-4bbf-bde2-95de813de375'
  imageRepository: 'workerapp'
  containerRegistry: 'votingregistry.azurecr.io'
  tag: '$(Build.BuildId)'

pool:
  name: 'azureagent'

stages:
- stage: Build
  jobs:
  - job: Build
    steps:
    - task: Docker@2
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'build'
        Dockerfile: 'worker/Dockerfile'
        tags: '$(tag)'

- stage: Push
  jobs:
  - job: Push
    steps:
    - task: Docker@2
      inputs:
        containerRegistry: '$(dockerRegistryServiceConnection)'
        repository: '$(imageRepository)'
        command: 'push'
        tags: '$(tag)'
```

---

# ⚠️ Known Issue

* Worker pipeline may fail
* Fix:

  * Go to `worker/Dockerfile`
  * Remove problematic `ENV` variable
  * Commit changes

---

# ✅ Summary

* Imported GitHub repo into Azure DevOps
* Created CI pipelines
* Configured self-hosted agent
* Built & pushed Docker images to ACR
* Handled pipeline failures

---

# 💡 Key Learnings

* CI pipelines automate build & push
* Self-hosted agents give flexibility
* Docker integration with ACR is seamless
* Debugging pipelines is a key DevOps skill

---
