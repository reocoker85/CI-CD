data "yandex_compute_image" "ubuntu" {
  family = var.family
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key = file("~/.ssh/id_rsa.pub")
  }

}

#=============================GITLAB SERVER =============================

resource "yandex_compute_instance" "gitlab" {
  name        = "gitlab"
  platform_id = "standard-v1"
  hostname    = "gitlab"

  resources {
    cores         = 4
    memory        = 6
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd8o6ukdc0jiattof4h5"
      size     = 20
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  metadata = {
    serial-port-enable = 1
    user-data          = data.template_file.cloudinit.rendered
  }
}

#=============================RUNNER=============================

resource "yandex_compute_instance" "runner" {
  name        = "runner"
  platform_id = "standard-v1"
  hostname    = "runner"
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 15
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true
  }
  metadata = {
    serial-port-enable = 1
    user-data          = data.template_file.cloudinit.rendered
  }
  provisioner "file" {
    source      = "${path.module}/start.sh"
    destination = "/home/user/start.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/runner_sonar_start.sh",
      "cd ~",
      "~/runner_sonar_start.sh"
    ]
  }
  connection {
    type        = "ssh"
    user        = "user"
    private_key = file("~/.ssh/id_rsa")
    host        = self.network_interface[0].nat_ip_address
  }
}


output "gitlab_ip" {
  description = "The external IP address of the instance"
  value       = yandex_compute_instance.gitlab.network_interface.0.nat_ip_address
}
output "runner_ip" {
  description = "The external IP address of the instance"
  value       = yandex_compute_instance.runner.network_interface.0.nat_ip_address
}
