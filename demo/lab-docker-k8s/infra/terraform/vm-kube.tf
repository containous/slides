resource "google_compute_instance" "vm_kube" {
  name         = "vm-kube-${count.index}"
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

  connection {
    type                = "ssh"
    bastion_host        = "${google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip}"
    bastion_user        = "${var.technical_user}"
    bastion_private_key = "${file("keys/id_rsa")}"
    user                = "${var.technical_user}"
    private_key         = "${file("keys/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "set -eux",
      "cd /home/${var.technical_user}/kube && docker-compose up -d --scale node=2",
      "mkdir -p /home/${var.technical_user}/.kube",
      "ln -s /home/${var.technical_user}/kube/kubeconfig.yaml /home/${var.technical_user}/.kube/config",
      "while [ ! -f /home/${var.technical_user}/kube/kubeconfig.yaml ];do echo \"No kubeconfig found yet.\";sleep 2;done",
      "kubectl --namespace kube-system create sa tiller",
      "kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller",
      "helm init --service-account tiller",
      "helm repo update",
      "kubectl apply -f /home/${var.technical_user}/kube/local-path-storage.yaml",
      "while [ \"$(kubectl get storageclass | grep -c local-path)\" -ne 1 ]; do echo \"waiting for storage\" class;sleep 2;done",
      "kubectl patch storageclass local-path -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"true\"}}}'",
    ]
  }
}
