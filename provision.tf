resource "null_resource" "provision" {

  provisioner "local-exec" {
    command = <<-EOF
    docker cp bootstrap.sh ${docker_container.controller.name}:/shared_volume/bootstrap.sh
    docker exec ${docker_container.controller.name} bash -c 'chmod +rx /shared_volume/bootstrap.sh'
    docker exec ${docker_container.controller.name} bash /shared_volume/bootstrap.sh
    docker exec ${docker_container.managed1.name} bash /shared_volume/bootstrap.sh
    docker exec ${docker_container.managed2.name} bash /shared_volume/bootstrap.sh
  EOF
  }

  # Dépendance explicite sur les ressources docker_container
  depends_on = [docker_container.controller, docker_container.managed1, docker_container.managed2]

}
