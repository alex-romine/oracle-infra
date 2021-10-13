resource "oci_core_vcn" "the_vcn" {
  compartment_id = var.compartment_id
  display_name   = "${var.resources_name_prefix}-vcn"
  cidr_blocks    = [var.vcn_cidr_block]
}

resource "oci_core_internet_gateway" "the_internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id = oci_core_vcn.the_vcn.id
}

resource "oci_core_default_route_table" "the_route_table" {
  manage_default_resource_id = oci_core_vcn.the_vcn.default_route_table_id

  route_rules {
    network_entity_id = oci_core_internet_gateway.the_internet_gateway.id
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
}

resource "oci_core_subnet" "the_subnet" {
  cidr_block     = var.subnet_cidr_block
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.the_vcn.id

  display_name = "${var.resources_name_prefix}-subnet"
}

resource "oci_core_default_security_list" "the_security_list" {
  manage_default_resource_id = oci_core_vcn.the_vcn.default_security_list_id

  compartment_id = var.compartment_id
  display_name   = "${var.resources_name_prefix}-security-list"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"

    description = "egress for subnet"
  }
  ingress_security_rules {
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = true
    tcp_options {
      max = 22
      min = 22
    }
  }
  ingress_security_rules {
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = true
    tcp_options {
      max = 443
      min = 443
    }
  }
  ingress_security_rules {
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = true
    tcp_options {
      max = 80
      min = 80
    }
  }
  ingress_security_rules {
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = true
    tcp_options {
      max = 6443
      min = 6443
    }
  }
}

resource "oci_core_instance" "the_instance" {
  display_name        = "${var.resources_name_prefix}-instance"
  availability_domain = "DeZS:US-SANJOSE-1-AD-1"
  compartment_id      = var.compartment_id
  shape               = "VM.Standard.A1.Flex"

  source_details {
    source_id   = "ocid1.image.oc1.us-sanjose-1.aaaaaaaaldzevh57b472rn7kmmnqphgmz62bx6l6rtmt2opkdtzzrahbejna"
    source_type = "image"
  }
  metadata = {
    ssh_authorized_keys     = file(pathexpand(var.public_ssh_key))
    boot_volume_size_in_gbs = "200"
  }

  create_vnic_details {
    assign_public_ip = true
    display_name     = "${var.resources_name_prefix}-vnic"
    subnet_id        = oci_core_subnet.the_subnet.id
  }

  shape_config {
    memory_in_gbs = 24
    ocpus         = 4
  }
}

output "instance_ip" {
  value = oci_core_instance.the_instance.public_ip
}
