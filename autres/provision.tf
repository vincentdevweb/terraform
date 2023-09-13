resource "null_resource" "provision" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<-EOT
      sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
      sudo systemctl restart sshd

      echo -e "192.168.10.3 controller.anslab.com controller\n192.168.10.4 managed1.anslab.com managed1\n192.168.10.5 managed2.anslab.com managed2" | sudo tee -a /etc/hosts

      sudo apt update && sudo apt -y install npm curl wget net-tools iputils-ping python3-pip sshpass

      if [[ $(hostname) = "controller" ]]; then
        sudo pip3 install ansible
      fi
    EOT
  }
}
