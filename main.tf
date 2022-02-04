terraform {
  required_version = ">= 0.14"

  required_providers {
    # Cloud Run support was added on 3.3.0
    google = ">= 3.3"
  }
}

provider "google" {
  project = "terraform-gcp-340013"
}

resource "google_project_service" "run_api" {
  service            = "run.googleapis.com"
}


resource "google_cloud_run_service" "run_service" {
  name     = "app1"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/terraform-gcp-340013/example:latest"
      }
    }
  }
    depends_on = [google_project_service.run_api]

}


data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.run_service.location
  project  = google_cloud_run_service.run_service.project
  service  = google_cloud_run_service.run_service.name

  policy_data = data.google_iam_policy.noauth.policy_data
}


output "service_url" {
  value = google_cloud_run_service.run_service.status[0].url
}