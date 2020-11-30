provider "google" {
  version     = "3.49.0"
  project     = var.PROJECT_ID
  region      = var.REGION
  credentials = file(var.CREDS)
}


provider "google-beta" {
  version     = "3.49.0"
  project     = var.PROJECT_ID
  region      = var.REGION
  credentials = file(var.CREDS)
}


terraform {
  required_version = ">=0.13.4"
  backend "gcs" {
    bucket = "learn-tf-1-state-bucket"
    prefix = "terraform/state"
  }
}


resource "random_id" "instance_id" {
  byte_length = 8
}


//
// ====================================================================
// Network:
// ====================================================================
//


resource "google_compute_network" "vpc" {
  project                 = var.PROJECT_ID
  name                    = "vpc-${var.PROJECT_ID}"
  auto_create_subnetworks = false
}


//resource "google_compute_subnetwork" "subnetwork-1" {
//  project       = var.PROJECT_ID
//  network       = google_compute_network.vpc.self_link
//  region        = var.REGION
//  name          = "sn-${var.PROJECT_ID}"
//  ip_cidr_range = "10.0.1.0/24"
//}
//
//
////
//// ====================================================================
//// Compute instances:
//// ====================================================================
////
//
//
//resource "google_compute_instance" "bastion" {
//  project                   = var.PROJECT_ID
//  name                      = "vm-${var.PROJECT_ID}-bastion"
//  machine_type              = "f1-micro"
//  zone                      = var.ZONE
//  allow_stopping_for_update = true
//
//  boot_disk {
//    initialize_params {
//      image = "debian-cloud/debian-10"
//    }
//  }
//
//  metadata_startup_script = <<EOF
//apt -qq update                 &&
//apt -qq upgrade -y
//EOF
//
//  network_interface {
//    subnetwork = google_compute_subnetwork.subnetwork-1.self_link
//
//    access_config {
//      // Ephemeral IP
//    }
//  }
//
//  metadata = {
//    ssh-keys = "jarppe:${file("~/.ssh/id_rsa.pub")}"
//  }
//}
//
//resource "google_compute_instance" "worker" {
//  project                   = var.PROJECT_ID
//  name                      = "vm-${var.PROJECT_ID}-worker"
//  machine_type              = "f1-micro"
//  zone                      = var.ZONE
//  allow_stopping_for_update = true
//
//  boot_disk {
//    initialize_params {
//      image = "debian-cloud/debian-10"
//    }
//  }
//
//  metadata_startup_script = <<EOF
//apt -qq update
//apt -qq upgrade -y
//apt -qq install -y curl xz-utils
//curl -sL https://nodejs.org/dist/v14.15.1/node-v14.15.1-linux-x64.tar.xz    \
//  | unxz -dc                                                                \
//  | tar xf - --strip-components=1 -C /usr/
//EOF
//
//  network_interface {
//    subnetwork = google_compute_subnetwork.subnetwork-1.self_link
//
//    access_config {
//      // Ephemeral IP
//    }
//  }
//
//  metadata = {
//    ssh-keys = "jarppe:${file("~/.ssh/id_rsa.pub")}"
//  }
//}
