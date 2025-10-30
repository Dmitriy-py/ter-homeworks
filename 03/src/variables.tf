###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

# Переменная для настройки SSH-пользователя
variable "ssh_user" {
  description = "User name for SSH connection on VMs"
  type        = string
  default     = "yc-user"
}

# Используем map(object)
variable "db_vm_specs" {
  description = "Configuration specifications for database VMs (main/replica)."
  type = map(object({
    cpu           = number
    ram           = number
    disk_volume   = number
  }))
  default = {
    "main" = {
      cpu           = 4
      ram           = 8 
      disk_volume   = 30
    },
    "replica" = {
      cpu           = 2
      ram           = 4
      disk_volume   = 15
    }
  }
}