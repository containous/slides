data "template_file" "attendee_infos" {
  count    = "${var.nb_attendees}"
  template = "http://lab-${format("%02d",count.index)}.shell.${var.domain}	lab-${format("%02d",count.index)}.${var.domain}	${google_compute_instance.vm_docker.*.network_interface.0.network_ip[count.index]}	${google_compute_instance.vm_kube.*.network_interface.0.network_ip[count.index]}"
}
