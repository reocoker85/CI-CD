###cloud vars
variable "token" {
  type        = string
  sensitive   = true
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  sensitive   = true
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  sensitive   = true
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


###vm-count vars
variable "family" {
  type        = string
  default     = "centos-7"
  description = "OS"
}



###for_each
variable "each_vm" {
  type = list(object({  vm_name     = string,
                        hostname    = string 
                        platform    = string, 
                        cores       = number, 
                        memory      = number, 
                        core_fr     = number,
                        disk_size   = number, 
                        preemptible = bool, 
                        nat         = bool }))
  default = [
    {
      vm_name     = "sonar-01"
      hostname    = "sonar-01"
      platform    = "standard-v1"
      cores       = 2
      memory      = 4
      core_fr     = 5
      disk_size   = 10 
      preemptible = true
      nat         = true
    },
    {
      vm_name     = "nexus-01"
      hostname    = "nexus-01"
      platform    = "standard-v1"
      cores       = 2
      memory      = 4
      core_fr     = 5
      disk_size   = 10
      preemptible = true
      nat         = true
    }
  ]
}
