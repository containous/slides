resource "google_compute_instance" "vm_docker" {
  name         = "vm-docker-${count.index}"
  count        = "${var.nb_attendees}"
  machine_type = "n1-standard-2"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "${var.vm_template}"
      size  = 20
    }
  }

  network_interface {
    network    = "${google_compute_network.devoxx_net.name}"
    subnetwork = "${google_compute_subnetwork.devoxx_subnet.name}"
  }

  metadata {
    sshKeys = "${var.technical_user}:${file("keys/id_rsa.pub")}"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
