resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "n1-standard-4"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "${var.vm_template}"
      size  = 20
      type  = "pd-ssd"
    }
  }

  network_interface {
    network    = "${google_compute_network.devoxx_net.name}"
    subnetwork = "${google_compute_subnetwork.devoxx_subnet.name}"

    access_config {
      // Ephemeral Public IP
    }
  }

  metadata {
    sshKeys = "${var.technical_user}:${file("keys/id_rsa.pub")}"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  connection {
    type        = "ssh"
    user        = "${var.technical_user}"
    private_key = "${file("keys/id_rsa")}"
  }

  provisioner "file" {
    source      = "keys/id_rsa"
    destination = "/tmp/id_rsa"
  }

  provisioner "file" {
    source      = "./bastion-provision"
    destination = "/home/${var.technical_user}/"
  }

  provisioner "file" {
    content     = "EXTERNAL_DOMAIN=bastion.${var.domain}"
    destination = "/home/${var.technical_user}/bastion-provision/.env"
  }

  provisioner "remote-exec" {
    inline = [
      "set -x",
      "sudo mkdir -p /home/${var.technical_user}/.ssh /root/.ssh",
      "sudo chmod 0700 /home/${var.technical_user}/.ssh",
      "sudo cp /tmp/id_rsa /home/${var.technical_user}/.ssh/id_rsa",
      "sudo cp /tmp/id_rsa /root/.ssh/id_rsa",
      "sudo chmod 0600 /home/${var.technical_user}/.ssh/id_rsa /root/.ssh/id_rsa",
      "sudo chown -R ${var.technical_user} /home/${var.technical_user}/.ssh",
      "cd /home/${var.technical_user}/bastion-provision && docker-compose up -d",
    ]
  }
}

resource "google_dns_managed_zone" "ddu_workshops" {
  name     = "${var.domain}"
  dns_name = "${var.domain}"
}

resource "google_dns_record_set" "bastion_wildcard" {
  name = "*.${google_dns_managed_zone.ddu_workshops.0.dns_name}"
  type = "A"
  ttl  = 60

  managed_zone = "${google_dns_managed_zone.ddu_workshops.0.name}"

  rrdatas = [
    "${google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip}",
  ]
}

resource "null_resource" "webshell" {
  count = "${var.nb_attendees}"

  triggers = {
    attendee_docker_vm = "${google_compute_instance.vm_docker.*.name[count.index]}"
    attendee_kube_vm   = "${google_compute_instance.vm_kube.*.name[count.index]}"
    webshellbastion    = "${join(",", google_compute_instance.bastion.*.id)}"
  }

  depends_on = ["google_compute_instance.bastion"]

  # Connect to bastion
  connection {
    type        = "ssh"
    host        = "${google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip}"
    user        = "${var.technical_user}"
    private_key = "${file("keys/id_rsa")}"
  }

  # Provision the webshell
  provisioner "remote-exec" {
    inline = [
      "set -eux",
      "docker kill shell-${format("%02d",count.index)}_webshell_1 || true",
      "docker rm -v -f shell-${format("%02d",count.index)}_webshell_1 || true",
      "cd ~/bastion-provision && COMPOSE_PROJECT_NAME=lab-${format("%02d",count.index)} EXTERNAL_DOMAIN=shell.${var.domain} docker-compose -f webshell.yml up --build --force-recreate -d",
    ]
  }
}
