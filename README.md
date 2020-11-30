# Hello Terraform

Jarppe learning TF

Useful resources:

* [gcloud reference](https://cloud.google.com/sdk/gcloud/reference/)
* [Overview of Cloud Billing concepts](https://cloud.google.com/billing/docs/concepts)

This study follows loosely [Getting started with Terraform on Google Cloud](https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform), [Automating GCP projects creation with Terraform](https://femrtnz.medium.com/automating-gcp-projects-with-terraform-d571f0d94742) and [GCP Kubernetes Exercise](https://www.karimarttila.fi/gcp/2020/11/28/gcp-kubernetes-exercise.html).

## Admin project

Before we can start using Terraform, we need an admin project and a Service Account with proper privileges. The Terraform can then use this Service Account to create actual project.

The script `init.sh` creates the project folder, admin project into that folder, an Service Account, and grants required privileges to the Servce account.


hello-tf-admin          hello-tf-admin              16059190849
hello-tf-infra          hello-tf-infra              168822726551

