terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "ubuntu" {
  name         = "ubuntu:23.04"
  keep_locally = false
}

resource "docker_network" "private_network" {
  name = "my_network"
}
# Ressource Docker
resource "docker_volume" "shared_volume" {
  name = "shared_volume" # Nom du volume partagé
}

resource "docker_container" "controller" {
  name     = var.container_controlleur_ubuntu # Nom du conteneur
  hostname = var.container_controlleur_ubuntu
  image    = docker_image.ubuntu.name # Image Docker à utiliser
  command  = ["tail", "-f", "/dev/null"]
  volumes {
    volume_name    = docker_volume.shared_volume.name
    container_path = "/shared_volume"
  }
  # Options supplémentaires du conteneur
  ports {
    internal = 80
    external = 8081
    ip       = "0.0.0.0" # Pour lier à toutes les adresses IP disponibles
  }
  networks_advanced {
    name = docker_network.private_network.name
  }
}

resource "docker_container" "managed2" {
  name     = var.container_managed2_ubuntu # Nom du conteneur
  hostname = var.container_managed2_ubuntu
  image    = docker_image.ubuntu.name # Image Docker à utiliser
  command  = ["tail", "-f", "/dev/null"]
  # Options supplémentaires du conteneur
  volumes {
    volume_name    = docker_volume.shared_volume.name
    container_path = "/shared_volume"
  }
  ports {
    internal = 80
    external = 8082
  }
  networks_advanced {
    name = docker_network.private_network.name
  }
}
resource "docker_container" "managed1" {
  name     = var.container_managed1_ubuntu # Nom du conteneur
  hostname = var.container_managed1_ubuntu
  image    = docker_image.ubuntu.name # Image Docker à utiliser
  command  = ["tail", "-f", "/dev/null"]
  # Options supplémentaires du conteneur
  volumes {
    volume_name    = docker_volume.shared_volume.name
    container_path = "/shared_volume"
  }
  ports {
    internal = 80
    external = 8083
  }
  networks_advanced {
    name = docker_network.private_network.name
  }
}

