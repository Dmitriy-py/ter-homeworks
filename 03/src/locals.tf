locals {
  ssh_public_key_content = file("~/.ssh/id_rsa.pub")

  ubuntu_image_id =  data.yandex_compute_image.ubuntu_latest.image_id

  vm_metadata = {
    user-data = templatefile("${path.module}/start-vm.tpl", {
      username = var.ssh_user
      ssh_key  = local.ssh_public_key_content
    })
  }

combined_vms_data = concat(
    [
      for instance in yandex_compute_instance.web : {
        name = instance.name
        id   = instance.id
        fqdn = instance.fqdn
      }
    ],
    [
      for instance in values(yandex_compute_instance.db) : {
        name = instance.name
        id   = instance.id
        fqdn = instance.fqdn
      }
    ],
    [
      {
        name = yandex_compute_instance.storage_vm.name
        id   = yandex_compute_instance.storage_vm.id
        fqdn = yandex_compute_instance.storage_vm.fqdn
      }
    ]
  )
}