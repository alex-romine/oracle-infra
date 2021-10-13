variable "compartment_id" {}

variable "config_file_profile" {}

variable "public_ssh_key" {}

variable "resources_name_prefix" {}

variable "tenancy_ocid" {}

variable "subnet_cidr_block" {
  default = "10.0.0.0/16"
}

variable "vcn_cidr_block" {
  default = "10.0.0.0/16"
}

################
### AWS Part ###
################

variable "aws_region" {}

variable "aws_zone_name" {}