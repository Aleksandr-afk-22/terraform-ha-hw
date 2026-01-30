resource "yandex_compute_instance" "web_servers" {
  count       = 2
  name        = "web-server-${count.index}"
  zone        = "ru-central1-a"  # зона должна соответствовать выбранной подсети
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = var.subnet_id  # ID подсети из Virtual Private Cloud → Subnets
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
    nat = true
  }

  metadata = {
    user-data = file("${path.module}/cloud-init.yml")
  }
}
