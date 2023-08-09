#  Основной файл конфигурации Terraform
provider "openstack" {
  auth_url  = "YOUR_AUTH_URL"
  user_name = "YOUR_USERNAME"
  password  = "YOUR_PASSWORD"
  tenant_name = "YOUR_TENANT_NAME"
}

resource "openstack_compute_instance_v2" "vm" {
  count      = 5
  name       = "vm${count.index + 1}"
  image_name = "CentOS 7"
  flavor_id  = "YOUR_FLAVOR_ID"
  key_pair   = "YOUR_KEYPAIR_NAME"
  security_groups = ["default"]
  network {
    name = "YOUR_NETWORK_NAME"
  }
}

resource "openstack_networking_floatingip_v2" "floating_ip" {
  count = 1
  pool  = "YOUR_FLOATING_IP_POOL_NAME"
}

resource "openstack_compute_floatingip_associate_v2" "float_ip_assoc" {
  count = 1
  floating_ip = openstack_networking_floatingip_v2.floating_ip.*.address[0]
  instance_id = openstack_compute_instance_v2.vm[0].id
}
