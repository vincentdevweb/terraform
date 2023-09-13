# Spécifie les providers requis et leurs sources. Ici, nous indiquons que nous voulons utiliser
# le provider Docker de kreuzwerker.
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker" # Source du provider Docker
    }
  }
}

# Configuration du provider Docker. Pas de paramètres spécifiques ici car nous utilisons les paramètres par défaut.
provider "docker" {}

resource "docker_volume" "shared_volume" {
  name = "shared_volume" # Nom du volume partagé
}

# Ressource pour télécharger l'image Docker d'Ubuntu. Cela garantit que l'image est présente avant de créer des conteneurs.
resource "docker_image" "ubuntu" {
  name = "ubuntu:latest" # Nom de l'image Docker à utiliser
}

resource "docker_network" "ansible" {
  name = "ansible_network" # Nom du réseau Docker à créer
}

# Ressource pour créer le conteneur Docker pour le controller.
resource "docker_container" "controller" {
  name  = "controller"             # Nom du conteneur
  image = docker_image.ubuntu.name # Utilise l'image précédemment définie

  # Commande pour garder le conteneur en cours d'exécution indéfiniment (utile pour les tests)
  command = ["/bin/bash", "-c", "while true; do sleep 30; done;"]

  hostname = "controller" # Nom d'hôte du conteneur

  networks_advanced {
    name = docker_network.ansible.name # Utilise le réseau précédemment défini
  }

  # Montage du script bootstrap.sh comme un volume à l'intérieur du conteneur
  volumes {
    volume_name    = docker_volume.shared_volume.name
    container_path = "/shared_volume"
  }

  volumes {
    host_path      = "/c/Users/Administrateur/Desktop/AWS/sol/lab_ansible-terraform/src"
    container_path = "/ansible"
  }

  provisioner "local-exec" {
    command = "docker cp bootstrap.sh ${docker_container.controller.name}:/shared_volume/bootstrap.sh && docker exec ${docker_container.controller.name} chmod +x /shared_volume/bootstrap.sh && docker exec ${docker_container.controller.name} /shared_volume/bootstrap.sh"
  }

}

# Ressource pour créer les conteneurs Docker pour les nœuds gérés.
resource "docker_container" "managed_node" {
  count = 2 # Crée 2 conteneurs de ce type

  # Utilise count.index pour donner un nom unique à chaque conteneur. count.index commence à 0.
  name = "managed${count.index + 1}" # Les noms seront managed1 et managed2

  image = docker_image.ubuntu.name # Utilise l'image précédemment définie


  networks_advanced {
    name = docker_network.ansible.name # Utilise le réseau précédemment défini
  }
  # Commande pour garder le conteneur en cours d'exécution indéfiniment (utile pour les tests)
  command = ["/bin/bash", "-c", "while true; do sleep 30; done;"]


  # Montage du script bootstrap.sh comme un volume à l'intérieur du conteneur
  volumes {
    volume_name    = docker_volume.shared_volume.name
    container_path = "/shared_volume"
  }

    provisioner "local-exec" {
    command = "docker exec ${self.name} /shared_volume/bootstrap.sh"
  }

    # Dépendance explicite sur les ressources docker_container
  depends_on = [docker_container.controller]

}


