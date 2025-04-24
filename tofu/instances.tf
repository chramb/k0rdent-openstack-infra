resource "openstack_compute_instance_v2" "management" {
  count		        = var.node_count
  name            = "${var.prefix}${var.instance_name}-${count.index}"
  image_name      = var.instance_image_name
  flavor_name     = var.instance_flavor_name
  security_groups = var.instance_security_groups

  network {
    uuid = openstack_networking_network_v2.k0rdent.id
  }

  user_data = base64encode(templatefile(
    "${path.module}/cloud-init.yml.tftpl", 
    { 
      ssh_public_key = var.ssh_public_key
    }))
}

