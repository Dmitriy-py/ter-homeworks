# Создание 3 дисков размером 1 ГБ
resource "yandex_compute_disk" "storage_disk" {
  count = 3

  name = "storage-disk-${count.index + 1}"
  zone = var.default_zone
  size = 1
  type = "network-ssd"
  
  folder_id = var.folder_id
}

resource "yandex_compute_instance" "storage_vm" {
  name = "storage"
  zone = var.default_zone
  
  resources {
    cores  = 2
    memory = 2
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = local.ubuntu_image_id
      size     = 10
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true
  }

  metadata = local.vm_metadata

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk
    
    content {
      disk_id = secondary_disk.value.id
      mode    = "READ_WRITE"
    }
  }
}