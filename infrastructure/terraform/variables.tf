variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "ecommerce"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "aks_node_count" {
  description = "Number of nodes in AKS cluster"
  type        = number
  default     = 1 # COST OPTIMIZATION: Single node for dev
}

variable "aks_node_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_B2s" # ~$30/month, cheapest for AKS (~$0.04/hour)
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.34"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "E-Commerce Microservices"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}
