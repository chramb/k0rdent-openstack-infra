data "openstack_networking_network_v2" "public" {
  name = "public"
}

resource "openstack_networking_network_v2" "k0rdent" {
  name = "${var.prefix}k0rdent"
}

resource "openstack_networking_subnet_v2" "k0rdent" {
  name           = "${var.prefix}k0rdent-subnet"
  network_id     = openstack_networking_network_v2.k0rdent.id
  cidr           = "10.41.12.0/24"
  ip_version      = 4
  dns_nameservers = var.dns_nameservers
}

resource "openstack_networking_router_v2" "k0rdent" {
  name           = "${var.prefix}k0rdent-management-router"
  admin_state_up = "true"
  external_network_id = data.openstack_networking_network_v2.public.id
}

resource "openstack_networking_router_interface_v2" "rt" {
  router_id = openstack_networking_router_v2.k0rdent.id
  subnet_id = openstack_networking_subnet_v2.k0rdent.id
}


resource "openstack_networking_floatingip_v2" "management" {
  count = var.node_count
  pool  = "public"
}

data "openstack_networking_port_v2" "management-port" {
  count	     = var.node_count
  device_id  = openstack_compute_instance_v2.management[count.index].id
  network_id = openstack_compute_instance_v2.management[count.index].network.0.uuid
}

resource "openstack_networking_floatingip_associate_v2" "management" {
  count       = var.node_count
  floating_ip = openstack_networking_floatingip_v2.management[count.index].address
  port_id     = data.openstack_networking_port_v2.management-port[count.index].id
}

