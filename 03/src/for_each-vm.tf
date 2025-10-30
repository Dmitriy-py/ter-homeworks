resource "yandex_compute_instance" "db" {
  for_each = var.db_vm_specs
  name = "db-${each.key}"
  zone = var.default_zone

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }
  
  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = local.ubuntu_image_id
      # Разный объем диска
      size     = each.value.disk_volume
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true
  }

  metadata = local.vm_metadata
}