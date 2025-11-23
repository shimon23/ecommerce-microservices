# Random suffix for unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false

  keepers = {
    # This ensures the suffix stays the same across destroy/apply
    project = var.project_name
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

# Log Analytics Workspace (for AKS monitoring)
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.project_name}-${var.environment}-logs"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}
