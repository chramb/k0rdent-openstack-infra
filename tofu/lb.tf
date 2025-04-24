# /*
locals {
  endpoints = {
    kubeAPI           = 6443
    #konnectivity      = 8132
    controllerJoinAPI = 9443
  }

  instance_port_map = merge([
    for i in openstack_compute_instance_v2.management:
    { for name, port in local.endpoints:
         "${i.name}-${name}" => {
            endpoint = name
            address = i.access_ip_v4
            port = port
         }
    }
  ]...)
}

resource "openstack_networking_floatingip_v2" "lb" {
  pool  = "public"
}

resource "openstack_networking_floatingip_associate_v2" "lb" {
  floating_ip = openstack_networking_floatingip_v2.lb.address
  port_id     = openstack_lb_loadbalancer_v2.control-plane.vip_port_id
}

resource "openstack_lb_loadbalancer_v2" "control-plane" {
  name          = "${var.prefix}k0rdnet-management-lb"
  vip_subnet_id = openstack_networking_subnet_v2.k0rdent.id
  depends_on    = [openstack_compute_instance_v2.management]
}

resource "openstack_lb_listener_v2" "control-plane" {
  for_each        = local.endpoints
  name            = each.key
  protocol        = "TCP"
  protocol_port   = each.value
  loadbalancer_id = openstack_lb_loadbalancer_v2.control-plane.id
}

resource "openstack_lb_pool_v2" "control-plane" {
  for_each    = local.endpoints
  name        = "${var.prefix}k0rdent-controlplane-${each.key}"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.control-plane[each.key].id
}

resource "openstack_lb_member_v2" "control-plane" {
  for_each      = local.instance_port_map
  address       = each.value.address
  protocol_port = each.value.port
  pool_id       = openstack_lb_pool_v2.control-plane[each.value.endpoint].id
  subnet_id     = openstack_networking_subnet_v2.k0rdent.id
}

resource "openstack_lb_monitor_v2" "control-plane" {
  for_each    = local.endpoints
  name        = "monitor_${each.key}"
  pool_id     = openstack_lb_pool_v2.control-plane[each.key].id
  type        = "TCP"
  delay       = 15
  timeout     = 15
  max_retries = 3
}
# */
