terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "*****"
  cloud_id  = "*****"
  folder_id = "*****"
  zone      = "ru-central1-a"
}

# VIRTUAL MACHINES >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

resource "yandex_compute_instance" "web-front" {
 
  name = "nginx-front"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true
  }

  boot_disk {
   initialize_params {
      image_id = "fd8hi77a48ojvj7nfaee"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-web.id
    nat = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

}

# NETWORKS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

resource "yandex_vpc_network" "network-web" {
  name = "web-docker"
}

resource "yandex_vpc_subnet" "subnet-web" {
  name           = "web-docker subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-web.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
