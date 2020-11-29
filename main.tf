provider "google" {
  version     = "~> 2.18.1"
  credentials = file("key.json")
  project     = "jarppe-gcp-test"
  region      = "europe-north1"
}

resource "random_id" "instance_id" {
  byte_length = 8
}

//
// ====================================================================
// Folders and project:
// ====================================================================
//


resource "google_folder" "jarppe_folder" {
  display_name = "Jarppe's play ground"
  parent       = "organizations/${var.ORGANIZATION_ID}"
}


resource "google_folder" "project_folder" {
  display_name = "Hello TF project folder"
  parent       = google_folder.jarppe_folder.name
}


resource "google_project" "project" {
  name       = var.PROJECT_NAME
  project_id = var.PROJECT_ID
  folder_id  = google_folder.project_folder.name
}


//
// ====================================================================
// Enable services for project:
// ====================================================================
//


resource "google_project_service" "cloudbilling" {
  project                    = google_project.project.project_id
  service                    = "cloudbilling.googleapis.com"
  disable_dependent_services = true
}


resource "google_project_service" "cloudresourcemanager" {
  project                    = google_project.project.project_id
  service                    = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "iam" {
  project                    = google_project.project.project_id
  service                    = "iam.googleapis.com"
  disable_dependent_services = true
}


resource "google_project_service" "compute" {
  project                    = google_project.project.project_id
  service                    = "compute.googleapis.com"
  disable_dependent_services = true
}


resource "google_project_service" "serviceusage" {
  project                    = google_project.project.project_id
  service                    = "serviceusage.googleapis.com"
  disable_dependent_services = true
}


//
// ====================================================================
// Service accounts and permissions:
// ====================================================================
//


resource "google_service_account" "admin_sa" {
  account_id   = "admin-sa"
  display_name = "Admin service-account"
  project      = google_project.project.project_id
}


resource "google_service_account" "infra_sa" {
  account_id   = "infra-sa"
  display_name = "Infra service-account"
  project      = google_project.project.project_id
}


data "google_iam_policy" "admin_policy" {
  binding {
    role = "roles/viewer"

    members = [
      google_service_account.admin_sa.unique_id
      // "serviceAccount:your-custom-sa@your-project.iam.gserviceaccount.com"
    ]
  }

  binding {
    role = "roles/storage.admin"

    members = [
      google_service_account.admin_sa.unique_id
      // "serviceAccount:your-custom-sa@your-project.iam.gserviceaccount.com"
    ]
  }
}


//
// ====================================================================
// Compute instances:
// ====================================================================
//


resource "google_compute_instance" "bastion" {
  name                      = "vm-${random_id.instance_id.hex}"
  machine_type              = "f1-micro"
  zone                      = "europe-north1-c"
  allow_stopping_for_update = true
  project                   = google_project.project.project_id

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  metadata_startup_script = <<EOF
apt -qq update                 &&
apt -qq upgrade -y
EOF

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "jarppe:${file("~/.ssh/id_rsa.pub")}"
  }
}
