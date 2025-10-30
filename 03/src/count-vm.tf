resource "yandex_compute_instance" "web" {
  count = 2 

  name = "web-${count.index + 1}" 
  zone = var.default_zone
  
  resources {
    cores  = 2
    memory = 2
  }
  
  scheduling_policy {
    preemptible = true
  }

  depends_on = [
    yandex_compute_instance.db
  ]

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
}