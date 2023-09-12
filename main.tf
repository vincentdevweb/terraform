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

# resource "docker_image" "nginx" {
#   name         = "nginx:latest"
#   keep_locally = false
# }

resource "docker_image" "ubuntu" {
  name         = "ubuntu:latest"
  keep_locally = false
}

# Ressource Docker
resource "docker_container" "container_controlleur_ubuntu" {
  name  = var.container_controlleur_ubuntu    # Nom du conteneur
  image = docker_image.ubuntu.name # Image Docker à utiliser

  # Options supplémentaires du conteneur
  ports {
    internal = 80
    external = 8081
  }
}

resource "docker_container" "container_M2_ubuntu" {
  name  = var.container_M2_ubuntu   # Nom du conteneur
  image = docker_image.ubuntu.name # Image Docker à utiliser

  # Options supplémentaires du conteneur
  ports {
    internal = 80
    external = 8082
  }
}

resource "docker_container" "container_M1_ubuntu" {
  name  = var.container_M1_ubuntu   # Nom du conteneur
  image = docker_image.ubuntu.name # Image Docker à utiliser

  # Options supplémentaires du conteneur
  ports {
    internal = 80
    external = 8083
  }
}

