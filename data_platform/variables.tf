variable "storage_account_name" {
  type        = string
  description = "Storage Account Name"
}

variable "key_vault_name" {
  type        = string
  description = "Key Vault Name"
}

variable "data_factory_name" {
  type        = string
  description = "Data Factory Name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}

variable "location" {
  type        = string
  description = "location"
  default     = "eastus"
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID"
  default     = "8abcf116-35fa-47ac-90ff-0d9db900a1a4"
}