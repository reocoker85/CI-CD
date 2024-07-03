data "yandex_compute_image" "centos" {
  family = var.family
}

resource "yandex_compute_instance" "vm" {
  for_each = {
    for index, vm in var.each_vm:
    vm.vm_name => vm
  }
  name        = each.value.vm_name
  hostname    = each.value.hostname
  platform_id = each.value.platform

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fr
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos.id
      size     = each.value.disk_size
    }
  }

  scheduling_policy {
    preemptible = each.value.preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = each.value.nat
  }
  
  metadata = {
    user-data          = data.template_file.cloudinit.rendered 
    serial-port-enable = 1
  }

  provisioner "file" {
    source = "~/03/py.sh"  
    destination = "/home/user/py.sh"    
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/py.sh",
          "cd ~",
          "~/py.sh"
    ]
  }
    connection {
      type = "ssh"
      user = "user" 
      private_key = file("~/.ssh/id_rsa") 
      host = self.network_interface[0].nat_ip_address
    }

  
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key     = file("~/.ssh/id_rsa.pub")
  }

}
