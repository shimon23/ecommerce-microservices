# E-Commerce Microservices Platform

![Status](https://img.shields.io/badge/status-in%20progress-yellow)
![Python](https://img.shields.io/badge/python-3.11-blue)
![Kubernetes](https://img.shields.io/badge/kubernetes-1.27-blue)
![Helm](https://img.shields.io/badge/helm-3.13-blue)

A production-ready microservices platform showcasing modern DevOps practices, cloud-native architecture, and full CI/CD pipeline implementation.

## 🎯 Project Overview

This project demonstrates end-to-end DevOps workflow for a microservices-based e-commerce platform, from local development to cloud deployment on Azure AKS with comprehensive monitoring and GitOps practices.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│                 Ingress Controller                  │
│              (Nginx / Azure App Gateway)            │
└─────────────────┬───────────────────────────────────┘
                  │
        ┌─────────┴─────────┐
        │                   │
┌───────▼────────┐  ┌──────▼─────────┐
│ Product Service│  │ Order Service  │
│  (Python/API)  │  │ (Python/API)   │
│  Port: 8000    │  │ Port: 8001     │
└───────┬────────┘  └──────┬─────────┘
        │                   │
        │    ┌──────────────┘
        │    │  HTTP Communication
        └────▼──────────────────────┐
        │  Kubernetes Services      │
        │  (Service Discovery)      │
        └───────────────────────────┘
```

### Microservices

- **Product Service**: Manages product catalog (CRUD operations)
- **Order Service**: Handles order processing, communicates with Product Service

## 🛠️ Tech Stack

### Development
- **Backend**: Python 3.11, FastAPI
- **API Documentation**: Swagger/OpenAPI
- **Containerization**: Docker, Multi-stage builds

### Orchestration & Deployment
- **Container Orchestration**: Kubernetes
- **Package Management**: Helm 3
- **Local K8s**: Docker Desktop / Minikube
- **Cloud Platform**: Azure AKS *(coming soon)*

### Infrastructure as Code
- **IaC**: Terraform *(coming soon)*
- **Cloud Resources**: Azure Container Registry, Azure Key Vault *(coming soon)*

### CI/CD & GitOps
- **CI/CD**: GitHub Actions *(coming soon)*
- **GitOps**: ArgoCD *(coming soon)*
- **Image Registry**: Azure Container Registry *(coming soon)*

### Observability
- **Metrics**: Prometheus *(coming soon)*
- **Visualization**: Grafana *(coming soon)*
- **Logging**: Azure Log Analytics *(coming soon)*
- **APM**: Application Insights *(coming soon)*

## 🚀 Quick Start

### Prerequisites

- Docker Desktop with Kubernetes enabled
- Python 3.11+
- kubectl
- Helm 3
- Git

### Local Development

#### 1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/ecommerce-microservices.git
cd ecommerce-microservices
```

#### 2. Run with Docker Compose (easiest)
```bash
# Build and start services
docker-compose up --build

# Access services
# Product Service: http://localhost:8000/docs
# Order Service: http://localhost:8001/docs
```

#### 3. Run on Kubernetes (local)
```bash
# Ensure Kubernetes is running
kubectl cluster-info

# Build Docker images
cd product-service && docker build -t product-service:latest .
cd ../order-service && docker build -t order-service:latest .
cd ..

# Deploy with Helm
helm install product-service ./helm/product-service
helm install order-service ./helm/order-service

# Check deployment
kubectl get pods

# Access services (port-forward)
kubectl port-forward svc/product-service 8000:8000
kubectl port-forward svc/order-service 8001:8001
```

### Testing the APIs

#### Product Service

```bash
# Get all products
curl http://localhost:8000/api/products

# Create a product
curl -X POST http://localhost:8000/api/products \
  -H "Content-Type: application/json" \
  -d '{"name": "Laptop", "price": 999.99, "stock": 50}'
```

#### Order Service

```bash
# Create an order
curl -X POST http://localhost:8001/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "items": [{"product_id": 1, "quantity": 2}],
    "customer_email": "test@example.com"
  }'

# Get all orders
curl http://localhost:8001/api/orders
```

## 📁 Project Structure

```
ecommerce-microservices/
├── product-service/           # Product microservice
│   ├── main.py               # FastAPI application
│   ├── requirements.txt      # Python dependencies
│   └── Dockerfile            # Multi-stage Docker build
├── order-service/            # Order microservice
│   ├── main.py               # FastAPI application
│   ├── requirements.txt      # Python dependencies
│   └── Dockerfile            # Multi-stage Docker build
├── helm/                     # Helm charts
│   ├── product-service/      # Product service chart
│   │   ├── Chart.yaml
│   │   ├── values.yaml       # Default values
│   │   ├── values-dev.yaml   # Dev environment overrides
│   │   ├── values-prod.yaml  # Production overrides
│   │   └── templates/
│   └── order-service/        # Order service chart
│       └── ...
├── k8s/                      # Raw Kubernetes manifests (reference)
│   ├── product-service/
│   └── order-service/
├── infrastructure/           # Terraform IaC (coming soon)
├── .github/workflows/        # CI/CD pipelines (coming soon)
├── docker-compose.yml        # Local development
└── README.md
```

## 🎓 Key Features & Best Practices

### DevOps Practices
- ✅ **Infrastructure as Code**: Helm charts for K8s, Terraform for cloud *(coming)*
- ✅ **Multi-stage Docker builds**: Optimized image sizes (~300MB vs 500MB+)
- ✅ **Health checks**: Liveness and readiness probes
- ✅ **Resource management**: CPU/Memory requests and limits
- ✅ **High Availability**: 2+ replicas per service
- ✅ **Service Discovery**: Kubernetes DNS for inter-service communication
- ✅ **GitOps workflow**: Git as single source of truth *(coming)*

### Architecture Decisions
- **Microservices pattern**: Independently deployable services
- **API-first design**: Swagger/OpenAPI documentation
- **Stateless services**: Horizontal scaling capability
- **Container orchestration**: Kubernetes for production-grade deployment
- **Secrets management**: Azure Key Vault integration *(coming)*

## 📊 Development Progress

### ✅ Completed (Week 1)
- [x] Day 1: Product Service development
- [x] Day 2: Order Service + Docker Compose
- [x] Day 3: Kubernetes local deployment
- [x] Day 4: Helm Charts implementation

### 🚧 In Progress (Week 2)
- [ ] Day 5-6: Terraform + Azure AKS infrastructure
- [ ] Day 7: Azure Container Registry + Key Vault
- [ ] Day 8-9: CI/CD pipeline with GitHub Actions
- [ ] Day 10-11: GitOps with ArgoCD
- [ ] Day 12-13: Monitoring stack (Prometheus + Grafana)
- [ ] Day 14: Documentation & demo video

## 🎯 Learning Outcomes

### Technical Skills Demonstrated
- Container orchestration at scale
- Infrastructure as Code (Helm, Terraform)
- CI/CD pipeline design and implementation
- Cloud-native architecture patterns
- Microservices communication patterns
- Kubernetes resource management
- Multi-environment deployment strategies

### Production Readiness
- Health checks and self-healing
- Resource optimization
- High availability configuration
- Security best practices
- Observability and monitoring
- Cost optimization strategies

## 🔧 Troubleshooting

### Common Issues

**Pods in ImagePullBackOff:**
```bash
# Ensure images are built locally
docker images | grep service

# If using local images, verify imagePullPolicy: Never
kubectl get deployment <service-name> -o yaml | grep imagePullPolicy
```

**Service communication fails:**
```bash
# Check service discovery
kubectl exec -it <pod-name> -- curl http://product-service:8000/health

# Verify services exist
kubectl get svc
```

**Helm deployment fails:**
```bash
# Lint charts before installing
helm lint ./helm/product-service

# Debug template rendering
helm template product-service ./helm/product-service --debug

# Check Helm release status
helm list
helm status product-service
```

## 📚 Documentation

- [API Documentation](http://localhost:8000/docs) - Swagger UI
- [Architecture Decisions](./docs/architecture.md) *(coming soon)*
- [Deployment Guide](./docs/deployment.md) *(coming soon)*
- [Monitoring Guide](./docs/monitoring.md) *(coming soon)*

## 🤝 Contributing

This is a personal learning project, but feedback and suggestions are welcome!

## 📝 License

MIT License - feel free to use this project for learning purposes.

## 👤 Author

**DevOps Engineer**
- Building modern cloud-native applications
- Learning in public and documenting the journey
- AWS Solutions Architect Associate certified
- Preparing for CKA (Certified Kubernetes Administrator)

---

## 🎬 Next Steps

Currently working on:
- Setting up Azure AKS infrastructure with Terraform
- Implementing full CI/CD pipeline
- Adding comprehensive monitoring and observability

**Last Updated:** November 2024  
**Status:** Active Development 🚀