#
# Variables

variable "nb_attendees" {
  default = 1
}

variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "vm_template" {
  default = "packer-1555448580"
}

variable "dns_zone_amount" {
  default = 1
}

variable "technical_user" {
  default = "devoxx"
}

variable "domain" {
  default = "ddu-workshops-1.com"
}
