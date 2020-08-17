provider "vsphere" {
  user           ="${var.user}"
  password       ="${var.password}"
  vsphere_server = "${var.host}"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "${var.region}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.cluster}/Resources"
 datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network_interface}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.templateName}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  count             = "${var.count}"
 name             = "${var.vmname}${format("%02d", count.index + 1 + var.offset)}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder = "${var.foldername}"

  num_cpus = 4
  memory   = 8192
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type= "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

wait_for_guest_net_timeout = 0

  disk {
    label = "windisk-${count.index}.vmdk"
    size  = 30
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
    timeout = 20
    windows_options {
       computer_name  = "${var.vmname}${format("%02d", count.index + 1 + var.offset)}"
       #computer_name  = "terraform-test"
	 join_domain = "itomcmp.servicenow.com"
        domain_admin_user = "serhiy.adm@itomcmp.servicenow.com"
        domain_admin_password = "cmpdev123"

      }

network_interface {
      }
    }
  }
}
