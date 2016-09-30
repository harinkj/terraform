provider "google" {
  alias = "harinkj"
  description = "harinkj"
  credentials = "${file("../accounts/Harin's First Project-866668b04610.json")}"
  project     = "quick-replica-95101"
  region      = "us-east1"
}
provider "google" {
  alias = "current"
//  description = "dowjonestest"
  credentials = "${file("../accounts/DowJonesTest-41c70b07f9e8.json")}"
  project     = "infra-agent-144815"
  region      = "us-east1"
}

resource "google_compute_network" "compute-network" {
  provider = "google.current"
  name       = "${var.network}"
}
resource "google_compute_subnetwork" "compute-subnetwork" {
  provider = "google.current"
  name          = "${var.subnetwork}"
  ip_cidr_range = "10.0.0.0/10"
  network       = "${google_compute_network.compute-network.self_link}"
  region        = "us-east1"
}
resource "google_compute_instance_template" "instance-template" {
  provider = "google.current"
  name        = "${var.instance-template}"
  description = "template description"

  tags = ["webserver"]

  instance_description = "description assigned to instances"
  machine_type         = "n1-standard-1"

  // Create a new boot disk from an image
  disk {
    source_image = "${var.image}"
  }
  network_interface {
    subnetwork = "${var.subnetwork}"
    access_config {}
    }

  metadata {
    startup_script = "echo \" EXPORT PROFILE=DEV\" > /etc/init.d/test.sh;chmod 755 /etc/init.d/test.sh"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_firewall" "computefirewall" {
  provider = "google.current"
  name    = "harinsfirstproject-firewall"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["80","443","22"]
  }

  target_tags = ["webserver"]
}

resource "google_compute_instance_group_manager" "instance-group-manager" {
  provider = "google.current"
  name        = "${var.instance-group-manager}"
  description = "Terraform test instance group manager"
  base_instance_name = "a-ubuntu-instance"
  instance_template  = "${google_compute_instance_template.instance-template.self_link}"
  update_strategy    = "NONE"
  zone               = "us-east1-b"

}
resource "google_compute_autoscaler" "foobar" {
  provider = "google.current"
  name   = "foobar"
  zone   = "us-east1-b"
  target = "${google_compute_instance_group_manager.instance-group-manager.self_link}"

  autoscaling_policy = {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}
