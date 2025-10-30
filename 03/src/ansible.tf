locals {
  web_hosts = [for instance in yandex_compute_instance.web : {
    name = instance.name
    ip   = instance.network_interface[0].nat_ip_address
    fqdn = instance.fqdn # Используем атрибут fqdn
  }]

  db_hosts = [for key, instance in yandex_compute_instance.db : {
    name = instance.name
    ip   = instance.network_interface[0].nat_ip_address
    fqdn = instance.fqdn
  }]

  storage_hosts = [{
    name = yandex_compute_instance.storage_vm.name
    ip   = yandex_compute_instance.storage_vm.network_interface[0].nat_ip_address
    fqdn = yandex_compute_instance.storage_vm.fqdn
  }]
}

resource "local_file" "ansible_inventory" {
  filename = "ansible-inventory.ini"
  
  content = templatefile("${path.module}/ansible-inventory.tpl", {
    webservers = local.web_hosts,
    databases  = local.db_hosts,
    storage    = local.storage_hosts
  })
  
  depends_on = [
    yandex_compute_instance.web,
    yandex_compute_instance.db,
    yandex_compute_instance.storage_vm
  ]
}