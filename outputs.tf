output "ip" {
  value = google_compute_instance.bastion.network_interface.network_ip
}
