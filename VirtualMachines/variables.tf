variable "admin_username" {
    type = string
    description = "Administrator user name for virtual machine"
}

variable "admin_password" {
    type = string
    description = "Password must meet Azure complexity requirements"
}

 variable "location" {
     type = string
     description = "resource location"
     default = "westus2"
 }

 var "vm_size" {
     type = string
     description = "virtual machine size"
     default = "Standard_DS1_v2"
 }