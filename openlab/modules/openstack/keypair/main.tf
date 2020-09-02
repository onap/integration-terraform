resource "openstack_compute_keypair_v2" "key" {
  # You cna find a public/private key pair from your remote state storage.
  name = "${var.cluster_name}-key"
  # In order to generate a new keypair via existing public key
  public_key = var.ssh_public_key
}
