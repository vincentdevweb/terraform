variable "container_nginx" {
  description = "name of docker nginx container example"
  type        = string
  default     = "my-docker-container-tutorial-via-variable"
}
variable "container_controlleur_ubuntu" {
  description = "name of docker ubuntu container controlleur"
  type        = string
  default     = "controller"
}
variable "container_managed1_ubuntu" {
  description = "name of docker ubuntu container M1"
  type        = string
  default     = "managed1"
}
variable "container_managed2_ubuntu" {
  description = "name of docker ubuntu container M2"
  type        = string
  default     = "managed2"
}

variable "host_path" {
  description = "Chemin d'hôte"
  type        = string
  default     = "C:\\Users\\Administrateur\\Desktop\\AWS\\terraform"
}