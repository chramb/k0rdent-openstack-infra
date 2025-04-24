resource "openstack_identity_application_credential_v3" "capi" {
  name        = "${var.prefix}capi"
  description = "Key for capi provider"
  secret      = var.capi_secret
}

output "clusterapi-creds" {
  sensitive = true
  value = <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: openstack-cloud-config
  namespace: kcm-system
stringData:
  clouds.yaml: |
    clouds:
      openstack:
        auth:
          auth_url: "${var.openstack_auth_url}"
          application_credential_id: ${openstack_identity_application_credential_v3.capi.id}
          application_credential_secret: ${openstack_identity_application_credential_v3.capi.secret}
        region_name: RegionOne
        interface: public
        identity_api_version: 3
        auth_type: v3applicationcredential
EOF
}
