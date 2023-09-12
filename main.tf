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

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

# Ressource Docker
resource "docker_container" "my_container_nginx" {
  name  = var.container_nginx     # Nom du conteneur
  image = docker_image.nginx.name # Image Docker à utiliser

  # Options supplémentaires du conteneur
  ports {
    internal = 80
    external = 8081
  }
}

output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.my_container_nginx.id
}

output "image_id" {
  description = "ID of the Docker image"
  value       = docker_image.nginx.id
}

