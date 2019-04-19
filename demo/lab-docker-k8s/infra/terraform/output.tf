output "bastion" {
  value = "${google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip}"
}

output "bastion_ssh" {
  value = "chmod 0600 ./keys/id_rsa && ssh -i ./keys/id_rsa -l ${var.technical_user} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip}"
}

output "attendees" {
  value = "${join("\n",data.template_file.attendee_infos.*.rendered)}"
}
