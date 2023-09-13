provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "libvirt_network" "private" {
  name      = "private"
  mode      = "nat"
  addresses = ["192.168.10.1/24"]
  dhcp {
    enabled = true
  }
}

resource "libvirt_domain" "controller" {
  name   = "controller"
  memory = 2048
  vcpu   = 2

  network_interface {
    network_name = libvirt_network.private.name
  }

  disk {
    volume_id = "controller.img"
    size      = "20G"
    pool      = "default"
    bus       = "virtio"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "/tmp/bootstrap.sh",
    ]
  }
}

# Define additional libvirt_domain resources for your other VMs (managed1, managed2, etc.) here.
resource "libvirt_domain" "managed1" {
  name   = "managed1"
  memory = 2048
  vcpu   = 2

  network_interface {
    network_name = libvirt_network.private.name
  }

  disk {
    volume_id = "managed1.img"
    size      = "20G"
    pool      = "default"
    bus       = "virtio"
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "/tmp/bootstrap.sh",
    ]
  }
}
