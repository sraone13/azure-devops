# 🚀 Day - 23: Terraform Azure VM Setup with Remote Backend

## 📌 Step 1: Create Infrastructure using Terraform

Create a `main.tf` file in VS Code to provision:

* Resource Group
* Virtual Network
* Subnet
* Network Interface
* Linux Virtual Machine

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources1"
  location = "Central India"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
```

### ▶️ Run Terraform Commands

```bash
terraform init
terraform plan
terraform apply
```

---

## 📌 Step 2: Configure Remote Backend (Azure Storage)

We store the Terraform state file in Azure Blob Storage.

Create a `backend.tf` file:

```hcl
terraform {
  backend "azurerm" {
    storage_account_name = "azurebackendstorageabhi"
    container_name       = "backend"
    key                  = "terraform.tfstate"
    access_key           = ""
  }
}
```

### 🔧 Steps:

1. Go to Azure Portal
2. Create **Storage Account**
3. Create a **Container** (e.g., `backend`)
4. Copy **Access Key** from:

   * Storage Account → Access Keys → Show

Paste it in `access_key`

---

### ▶️ Initialize Backend

```bash
terraform init
```

✅ Now Terraform state file will be stored in Azure Blob Storage

---

## 📌 Step 3: Add Public IP to VM

### Add this resource in `main.tf`:

```hcl
resource "azurerm_public_ip" "example" {
  name                = "example_pip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "dev"
  }
}
```

---

### 🔧 Update Network Interface

Add this line inside `ip_configuration`:

```hcl
public_ip_address_id = azurerm_public_ip.example.id
```

---

### ▶️ Apply Changes

```bash
terraform init
terraform plan
terraform apply
```

✅ Terraform will now:

* Fetch state from Azure
* Create Public IP
* Attach it to VM

---

## 📌 Step 4: SSH into VM

```bash
ssh -i ~/.ssh/id_rsa adminuser@<public-ip>
```

---

## ⚠️ Important Notes

* Ensure **NSG allows port 22 (SSH)**
* Public IP must be **Standard SKU**
* Backend setup is **one-time activity**

---

## 🎯 Summary

* Created Azure Infra using Terraform
* Configured Remote Backend (Azure Blob)
* Added Public IP to VM
* Connected via SSH

---

🔥 This is a complete real-world DevOps setup for Terraform + Azure
