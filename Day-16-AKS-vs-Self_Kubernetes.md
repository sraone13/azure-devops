# Day 16 - Kubernetes on Azure (On-Prem vs Azure VM vs AKS)

## Kubernetes Deployment Options

1. On-Premise (Self-Managed)
2. Azure VM-Based Kubernetes (Self-Managed)
3. AKS (Azure Kubernetes Service - Managed)

---

## Comparison Table

| Feature | On-Premise Kubernetes | Azure VM (Self-Managed K8s) | AKS (Managed K8s) |
|--------|----------------------|-----------------------------|-------------------|
| **Infrastructure** | Data Center / OpenStack | Azure Virtual Machines | Azure Managed Service |
| **Cluster Management** | Fully manual | Manual (on VMs) | Managed by Azure |
| **Control Plane** | Self-managed | Self-managed | Fully managed by Azure |
| **Maintenance** | High (manual upgrades, patching) | Moderate | Low (Azure handles updates) |
| **Cost** | High initial cost (hardware) | Pay-as-you-go | Optimized (pay for nodes only) |
| **Scaling** | Manual | Manual / Partial Auto | Easy Autoscaling |
| **Availability** | Limited | Better than on-prem | High availability |
| **Integration** | Manual setup | Azure integrations possible | Native Azure integrations |
| **Security** | Fully manual | Cloud-assisted | Built-in + Azure AD integration |
| **Load Balancer** | MetalLB (manual) | Azure LB (configured) | Built-in Azure Load Balancer |
| **Storage (CSI)** | Manual setup | Azure Disk/Files | Native CSI integration |
| **Secrets Management** | Manual | Possible with Azure | Azure Key Vault integration |
| **Node Management** | Manual | VM-based | Node Pools (VMSS) |
| **Autoscaling** | Not available / Manual | Possible but complex | Built-in Autoscaling |
| **Ease of Use** | Complex | Moderate | Easy |

---

## AKS Architecture Overview

### Control Plane (Managed by Azure)
- API Server  
- Scheduler  
- etcd  

### Node Pools
- Runs on VM Scale Sets (VMSS)
- Supports autoscaling
- High availability

---

## Infrastructure as Code (IaC)

- Tool: Terraform

### Usage:
- Automate provisioning of:
  - On-Prem infrastructure
  - Azure VMs
  - AKS clusters

---

## Summary

- **On-Prem** → Full control, high maintenance  
- **Azure VM** → Cloud infra but still manual K8s  
- **AKS** → Fully managed, scalable, production-ready  

---