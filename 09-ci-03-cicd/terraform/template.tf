
data "template_file" "inventory" {
   template = "${file("hosts")}"

    vars = {

             sonar_ip = "${yandex_compute_instance.vm["sonar-01"].network_interface.0.nat_ip_address}"
             nexus_ip = "${yandex_compute_instance.vm["nexus-01"].network_interface.0.nat_ip_address}"
    }
}

resource "null_resource" "update_inventory" {

    triggers = {
        template = "${data.template_file.inventory.rendered}"
    }

    provisioner "local-exec" {
        command = "echo '${data.template_file.inventory.rendered}' > /home/vagrant/03/infrastructure/inventory/cicd/hosts.yml"
    }
}
