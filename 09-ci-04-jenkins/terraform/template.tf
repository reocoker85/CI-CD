
data "template_file" "inventory" {
   template = "${file("hosts")}"

    vars = {

             master_ip = "${yandex_compute_instance.vm["jenkins-master-01"].network_interface.0.nat_ip_address}"
             agent_ip = "${yandex_compute_instance.vm["jenkins-agent-01"].network_interface.0.nat_ip_address}"
    }
}

resource "null_resource" "update_inventory" {
  provisioner "local-exec" {
        command = "echo '${data.template_file.inventory.rendered}' > /home/reocoker/cicd/mnt-homeworks/09-ci-04-jenkins/infrastructure/inventory/cicd/hosts.yml"
    }

    triggers = {
        template = "${data.template_file.inventory.rendered}"
    }

}

resource "null_resource" "ansible" {
  depends_on = [ null_resource.update_inventory ]
  provisioner "local-exec" {
    command = "cat ~/.ssh/id_rsa | ssh-add -"
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "local-exec" {
    command     = "export ANSIBLE_CONFIG=/home/reocoker/cicd/mnt-homeworks/09-ci-04-jenkins/infrastructure/ansible.cfg; ansible-playbook -i /home/reocoker/cicd/mnt-homeworks/09-ci-04-jenkins/infrastructure/inventory/cicd/hosts.yml /home/reocoker/cicd/mnt-homeworks/09-ci-04-jenkins/infrastructure/site.yml"
    on_failure  = continue 
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  }


}