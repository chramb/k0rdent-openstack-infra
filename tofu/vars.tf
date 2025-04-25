variable "node_count" {
  type = number
  default = 3
}

variable "prefix" {
  type = string
  default = ""
}

variable "node_role" {
  type = string 
  default = "controller+worker"
}

variable "instance_name" {
  type = string
}

variable "instance_image_name" {
  type = string
  default = "k0rdent-management"
}

variable "instance_flavor_name" {
  type = string
  default = "m1.medium"
}

variable "instance_security_groups" {
  type = list(string)
  default = ["all", "default"]
}

variable "capi_secret" {
  type = string
  sensitive = true
}

variable "openstack_auth_url" {
  type = string
  sensitive = true
}

variable "dns_zone_name" {
  type = string
}

variable "dns_management_record" {
  type = string
}

variable "dns_zone_email" {
  type = string
  default = ""
}

variable "dns_nameservers" {
  type = list(string)
}

variable "ssh_public_key" {
  type = string
}

variable "cloud_init_extra" {
  type = string
}
