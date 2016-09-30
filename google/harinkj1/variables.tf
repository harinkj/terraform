variable "network" {
  default = "network-us-east1"
}
variable "subnetwork" {
  default = "subnetwork-us-east1"
}
variable "instance-template" {
  default = "instance-template-a-ubuntu"
}
variable "image" {
  default = "https://www.googleapis.com/compute/v1/projects/quick-replica-95101/global/images/a-ubuntu-trusty"
}
variable "instance-group-manager" {
  default = "instance-group-manager"
}
variable "zones" {
  default = ["us-east-1a", "us-east-1b"]
}
