## Firewall rule to allow incoming request to VMs
resource "google_compute_firewall" "http" {
  name    = "http"
  network = "${google_compute_network.devoxx_net.name}"

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "6443", "8080"]
  }
}

resource "google_compute_firewall" "ssh" {
  name    = "ssh"
  network = "${google_compute_network.devoxx_net.name}"

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

## NAT configuration to allow VMs to access the Internet
resource "google_compute_router" "devoxx_nat_router" {
  name    = "devoxx-nat-router"
  region  = "${var.region}"
  network = "${google_compute_network.devoxx_net.name}"
}

resource "google_compute_router_nat" "devoxx_nat" {
  name                               = "devoxx-nat"
  router                             = "${google_compute_router.devoxx_nat_router.name}"
  region                             = "${var.region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_subnetwork" "devoxx_subnet" {
  name          = "devoxx-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "${var.region}"
  network       = "${google_compute_network.devoxx_net.name}"
}

resource "google_compute_network" "devoxx_net" {
  name                    = "devoxx-net"
  auto_create_subnetworks = false
}
