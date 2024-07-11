
#data "template_file" "inventory" {
#   template = "${file("docker-compose2")}"
#
#    vars = {
#
#             teamcity_server_ip = "${yandex_compute_instance.teamcity-server.network_interface.0.nat_ip_address}"
#    }
#}
#
#resource "null_resource" "update_inventory" {
#  provisioner "local-exec" {
#        command = "echo '${data.template_file.inventory.rendered}' > ${path.module}/docker-compose2.yaml"
#    }
#
#    triggers = {
#        template = "${data.template_file.inventory.rendered}"
#    }
#
#}

#resource "null_resource" "ansible" {
#  depends_on = [ null_resource.update_inventory ]
#  provisioner "local-exec" {
#    command = "eval $(ssh-agent) && cat ~/.ssh/id_rsa | ssh-add -"
#  }
#
#  provisioner "local-exec" {
#    command = "sleep 60"
#  }
#
#  provisioner "local-exec" {
#    command     = "export ANSIBLE_CONFIG=/home/vagrant/git/09-ci-04-jenkins/infrastructure/ansible.cfg; ansible-playbook -i /home/vagrant/git/09-ci-04-jenkins/infrastructure/inventory/cicd/hosts.yml /home/vagrant/git/09-ci-04-jenkins/infrastructure/site.yml"
#    on_failure  = continue  
#  }
#}
