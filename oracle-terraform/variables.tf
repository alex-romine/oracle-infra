variable "compartment_id" {}

variable "config_file_profile" {}

variable "public_ssh_key" {}

variable "resources_name_prefix" {}

variable "tenancy_ocid" {}

variable "availability_domain" {
  default = "DeZS:US-SANJOSE-1-AD-1"
}

variable "subnet_cidr_block" {
  default = "10.0.0.0/16"
}

variable "vcn_cidr_block" {
  default = "10.0.0.0/16"
}

