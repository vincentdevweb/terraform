variable "container_nginx" {
  description = "name of docker nginx container example"
  type        = string
  default     = "my-docker-container-tutorial-via-variable"
}
variable "container_controlleur_ubuntu" {
  description = "name of docker ubuntu container controlleur"
  type        = string
  default     = "controlleur"
}
variable "container_M1_ubuntu" {
  description = "name of docker ubuntu container M1"
  type        = string
  default     = "M1"
}
variable "container_M2_ubuntu" {
  description = "name of docker ubuntu container M2"
  type        = string
  default     = "M2"
}