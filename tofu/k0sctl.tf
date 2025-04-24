output "k0sctl" {
  value = templatefile("${path.module}/k0sctl.yml.tftpl",
  { 
    address_public  = [ for ip in openstack_networking_floatingip_v2.management: ip.address]
    address_private = [ for node in openstack_compute_instance_v2.management:  node.access_ip_v4]
    role = var.node_role

    external_address = openstack_networking_floatingip_v2.lb.address
    dns_name         = var.dns_management_record

  })
}



