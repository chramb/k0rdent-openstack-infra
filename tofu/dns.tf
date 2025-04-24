# /*
resource "openstack_dns_zone_v2" "k0rdent" {
  name        = var.dns_zone_name
  email       = var.dns_zone_email
  description = "An example zone"
  ttl         = 30
  type        = "PRIMARY"
}

resource "openstack_dns_recordset_v2" "k0rdent" {
  zone_id     = openstack_dns_zone_v2.k0rdent.id
  name        = var.dns_management_record
  description = "k0rdent mgmt server entry"
  ttl         = 30
  type        = "A"
  records     = [openstack_networking_floatingip_v2.lb.address]
}
# */

