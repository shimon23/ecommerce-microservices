# E-Commerce Microservices Platform

![Status](https://img.shields.io/badge/status-production-green)
![Azure](https://img.shields.io/badge/azure-AKS-blue)
![Python](https://img.shields.io/badge/python-3.11-blue)
![Kubernetes](https://img.shields.io/badge/kubernetes-1.28-blue)
![Terraform](https://img.shields.io/badge/terraform-IaC-purple)

> **Production-ready microservices platform deployed on Azure AKS, demonstrating modern DevOps practices, cloud-native architecture, and infrastructure as code.**

[🎬 Live Demo](#) | [📖 Documentation](#documentation) | [🚀 Deployment Guide](#deployment)

---

## 🎯 Project Overview

A complete end-to-end DevOps implementation showcasing:
- 🏗️ **Infrastructure as Code** with Terraform
- ☁️ **Cloud Deployment** on Azure AKS
- 🐳 **Containerization** with Docker
- ⎈ **Orchestration** with Kubernetes & Helm
- 🔄 **CI/CD** workflows (in progress)
- 📊 **Observability** & monitoring (planned)

---

## 🏗️ Architecture

```
                    ┌─────────────────────┐
                    │   Azure Cloud       │
                    │                     │
    ┌───────────────┴──────────────────┐  │
    │  Azure Kubernetes Service (AKS)  │  │
    │  ┌────────────────────────────┐  │  │
    │  │   Ingress Controller       │  │  │
    │  └──────────┬─────────────────┘  │  │
    │             │                     │  │
    │    ┌────────┴────────┐            │  │
    │    │                 │            │  │
    │  ┌─▼──────────┐  ┌──▼─────────┐  │  │
    │  │  Product   │  │   Order    │  │  │
    │  │  Service   │  │  Service   │  │  │
    │  │  (x2)      │  │   (x2)     │  │  │
    │  └────────────┘  └────────────┘  │  │
    │                                   │  │
    └───────────────────────────────────┘  │
    │                                      │
    │  ┌──────────────────────────────┐   │
    │  │ Azure Container Registry     │   │
    │  │ (Docker Images)              │   │
    │  └──────────────────────────────┘   │
    │                                      │
    │  ┌──────────────────────────────┐   │
    │  │ Azure Key Vault              │   │
    │  │ (Secrets Management)         │   │
    │  └──────────────────────────────┘   │
    └──────────────────────────────────────┘
```

### Microservices

- **Product Service** (Port 8000): Product catalog management with CRUD operations
- **Order Service** (Port 8001): Order processing with product validation via HTTP

---

## 🛠️ Technology Stack

### Cloud & Infrastructure
- **Cloud Platform**: Microsoft Azure
- **Kubernetes**: Azure Kubernetes Service (AKS) - v1.28
- **Container Registry**: Azure Container Registry (ACR)
- **Secrets**: Azure Key Vault
- **Networking**: Azure VNet, NSG, Load Balancer
- **Monitoring**: Azure Log Analytics

### Infrastructure as Code
- **Terraform**: Infrastructure provisioning
- **Helm 3**: Kubernetes package management
- **Multi-environment**: Dev/Staging/Prod configurations

### Application
- **Language**: Python 3.11
- **Framework**: FastAPI (async)
- **API Docs**: Swagger/OpenAPI
- **Containerization**: Docker (multi-stage builds)

### DevOps Tools
- **Version Control**: Git, GitHub
- **Container Orchestration**: Kubernetes
- **CI/CD**: GitHub Actions (in progress)
- **GitOps**: ArgoCD (planned)

---

## 🚀 Quick Start

### Prerequisites

- Azure Subscription
- Azure CLI (`az`)
- Terraform (`>= 1.0`)
- kubectl
- Helm 3
- Docker

### Deploy to Azure

#### 1. Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/ecommerce-microservices.git
cd ecommerce-microservices
```

#### 2. Login to Azure
```bash
az login
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

#### 3. Deploy Infrastructure
```bash
cd infrastructure/terraform

# Initialize Terraform
terraform init

# Deploy (10-15 minutes)
terraform apply

# Or use the helper script:
./deploy.ps1  # Windows
./deploy.sh   # Linux/Mac
```

#### 4. Connect to AKS
```bash
# Get AKS credentials
az aks get-credentials \
    --resource-group $(terraform output -raw resource_group_name) \
    --name $(terraform output -raw aks_cluster_name)

# Verify connection
kubectl get nodes
```

#### 5. Build & Push Images
```bash
cd ../..

# Login to ACR
ACR_NAME=$(cd infrastructure/terraform && terraform output -raw acr_name)
az acr login --name $ACR_NAME

# Get ACR login server
ACR_LOGIN_SERVER=$(cd infrastructure/terraform && terraform output -raw acr_login_server)

# Build and push Product Service
cd product-service
docker build -t product-service:v1.0.0 .
docker tag product-service:v1.0.0 $ACR_LOGIN_SERVER/product-service:v1.0.0
docker push $ACR_LOGIN_SERVER/product-service:v1.0.0
cd ..

# Build and push Order Service
cd order-service
docker build -t order-service:v1.0.0 .
docker tag order-service:v1.0.0 $ACR_LOGIN_SERVER/order-service:v1.0.0
docker push $ACR_LOGIN_SERVER/order-service:v1.0.0
cd ..
```

#### 6. Deploy Services
```bash
# Update Helm values with your ACR
# Edit helm/*/values-azure.yaml and set your ACR name

# Deploy with Helm
helm install product-service ./helm/product-service \
    -f ./helm/product-service/values-azure.yaml

helm install order-service ./helm/order-service \
    -f ./helm/order-service/values-azure.yaml

# Check deployment
kubectl get pods
kubectl get svc
```

#### 7. Access Services
```bash
# Port-forward to access locally
kubectl port-forward svc/product-service 8000:8000
kubectl port-forward svc/order-service 8001:8001

# Access Swagger UI
# Product Service: http://localhost:8000/docs
# Order Service: http://localhost:8001/docs
```

---

## 💰 Cost Optimization

The infrastructure includes cost-saving features:

- **Single-node cluster** for development (~$30/month if running 24/7)
- **Destroy/Deploy scripts** for daily usage (~$0.50/day)
- **Auto-scaling disabled** in dev (enable for prod)
- **Basic SKU** for ACR and other services

### Daily Workflow
```bash
# Morning - Start work
cd infrastructure/terraform
./deploy.ps1        # 10 minutes to create

# Evening - End work
./destroy.ps1       # 5 minutes to destroy
# Saves ~$2-4/day!
```

---

## 📊 Project Features

### ✅ Completed
- [x] Microservices architecture (2 services)
- [x] FastAPI REST APIs with OpenAPI docs
- [x] Docker containerization with multi-stage builds
- [x] Local Kubernetes deployment
- [x] Helm charts for package management
- [x] Azure AKS production deployment
- [x] Terraform infrastructure as code
- [x] Azure Container Registry integration
- [x] Azure Key Vault for secrets
- [x] Health checks (liveness & readiness probes)
- [x] Resource limits and requests
- [x] High availability (2 replicas per service)
- [x] Service discovery and inter-service communication
- [x] Cost optimization scripts

### 🚧 In Progress
- [ ] CI/CD pipeline with GitHub Actions
- [ ] GitOps with ArgoCD
- [ ] Prometheus & Grafana monitoring
- [ ] Centralized logging
- [ ] API Gateway / Ingress setup
- [ ] SSL/TLS certificates

---

## 🎓 Key Learning Outcomes

### Technical Skills
- Infrastructure as Code with Terraform
- Kubernetes orchestration at scale
- Azure cloud services (AKS, ACR, Key Vault, VNet)
- Container best practices (multi-stage builds, security)
- Helm package management
- Microservices communication patterns
- DevOps workflows and automation

### Production Practices
- High availability configuration
- Health monitoring and self-healing
- Resource optimization
- Security best practices (secrets management, network isolation)
- Cost management strategies
- Multi-environment deployments

---

## 📁 Project Structure

```
ecommerce-microservices/
├── product-service/           # Product microservice
│   ├── main.py               # FastAPI application
│   ├── requirements.txt      
│   └── Dockerfile            # Multi-stage build
├── order-service/            # Order microservice
│   ├── main.py
│   ├── requirements.txt
│   └── Dockerfile
├── infrastructure/
│   └── terraform/            # Infrastructure as Code
│       ├── main.tf           # Resource group, workspace
│       ├── aks.tf            # AKS cluster configuration
│       ├── acr.tf            # Container registry
│       ├── networking.tf     # VNet, subnets, NSG
│       ├── keyvault.tf       # Secrets management
│       ├── variables.tf      # Input variables
│       ├── outputs.tf        # Output values
│       ├── deploy.ps1        # Deployment script
│       └── destroy.ps1       # Cleanup script
├── helm/                     # Helm charts
│   ├── product-service/
│   │   ├── values.yaml       # Default values
│   │   ├── values-azure.yaml # Azure-specific
│   │   └── templates/
│   └── order-service/
│       └── ...
├── k8s/                      # Raw K8s manifests (reference)
└── docker-compose.yml        # Local development
```

---

## 🧪 Testing

### API Testing

**Product Service:**
```bash
# Get all products
curl http://localhost:8000/api/products

# Create product
curl -X POST http://localhost:8000/api/products \
  -H "Content-Type: application/json" \
  -d '{"name": "Laptop", "price": 999.99, "stock": 50}'
```

**Order Service:**
```bash
# Create order
curl -X POST http://localhost:8001/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "items": [{"product_id": 1, "quantity": 2}],
    "customer_email": "test@example.com"
  }'
```

---

## 🔧 Troubleshooting

### Common Issues

**Pods in ImagePullBackOff:**
```bash
# Check image exists in ACR
az acr repository list --name $ACR_NAME

# Verify AKS can pull from ACR
az aks check-acr --name $AKS_NAME --resource-group $RG_NAME --acr $ACR_NAME.azurecr.io
```

**Service communication fails:**
```bash
# Test from within cluster
kubectl exec -it <pod-name> -- curl http://product-service:8000/health

# Check service DNS
kubectl exec -it <pod-name> -- nslookup product-service
```

**Terraform state issues:**
```bash
# Refresh state
terraform refresh

# If corrupted, import resources
terraform import azurerm_resource_group.main /subscriptions/.../resourceGroups/...
```

---

## 📚 Documentation

- [Architecture Decisions](./docs/architecture.md) (coming soon)
- [Deployment Guide](./docs/deployment.md) (coming soon)
- [API Documentation](http://localhost:8000/docs) (Swagger)
- [Monitoring Setup](./docs/monitoring.md) (coming soon)

---

## 🤝 Contributing

This is a personal learning project, but feedback and suggestions are welcome!

---

## 📝 License

MIT License - feel free to use for learning purposes.

---

## 👤 Author

**DevOps Engineer**
- 🚀 Building production-ready cloud-native applications
- ☁️ Azure & AWS certified
- ⎈ Kubernetes enthusiast (CKA in progress)
- 📚 Learning in public and documenting the journey

**Connect:**
- LinkedIn: [Shimon Hagag](https://www.linkedin.com/in/shimon-hagag/)

---

## 🎯 Project Status

**Current Phase:** Production deployment on Azure AKS ✅  
**Next Steps:** CI/CD automation, monitoring & observability  
**Last Updated:** November 2024

**Active Development:** This project is being actively developed with regular commits. Check back for updates!

---

## 💡 Acknowledgments

Built with passion for DevOps and cloud-native technologies. Special thanks to the open-source community for the amazing tools and resources.

---

**⭐ If you find this project helpful, please consider giving it a star!**
