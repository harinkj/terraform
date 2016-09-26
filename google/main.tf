provider "google" {
  credentials = "${file("Harin's First Project-866668b04610.json")}"
  project     = "quick-replica-95101"
  region      = "us-east1"
}

resource "google_compute_instance" "east1-d" {
  name         = "harin-east1-d"
  machine_type = "n1-standard-1"
  zone         = "us-east1-d"

  tags = ["tomcatserver"]

  disk {
    image = "centos-7"
  }

  // Local SSD disk
  disk {
    type    = "local-ssd"
    scratch = true
  }

  network_interface {
//    network = "default"
      subnetwork = "harinsfirstproject-network-us-east1"
    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = [ "compute-rw", "storage-full"]
  }
}
resource "google_compute_firewall" "defaultfirewall" {
  name    = "harinsfirstproject-firewall"
  network = "${google_compute_network.default-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80","443","22"]
  }

  target_tags = ["tomcatserver"]
}
resource "google_compute_network" "default-network" {
  name       = "harinsfirstproject-network"
  //ipv4_range = "10.0.0.0/16"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "default-us-east1" {
  name          = "harinsfirstproject-network-us-east1"
  ip_cidr_range = "10.0.0.0/10"
  network       = "${google_compute_network.default-network.self_link}"
  region        = "us-east1"
}
