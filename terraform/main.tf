terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

# Data sources to get existing droplets
data "digitalocean_droplet" "existing_nodes" {
  count = length(var.existing_droplet_names)
  name  = var.existing_droplet_names[count.index]
}

# SSH key resource
resource "digitalocean_ssh_key" "cluster_key" {
  name       = "${var.cluster_name}-key"
  public_key = file("${var.private_key_path}.pub")
}

# Create com2 droplet only
resource "digitalocean_droplet" "com2" {
  image    = var.image
  name     = "com2"
  region   = var.region
  size     = var.com2_size
  ssh_keys = [digitalocean_ssh_key.cluster_key.fingerprint]
  tags     = var.tags

  # Remove remote-exec provisioner to avoid hanging
}

# Generate Ansible inventory
resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.ini"
  content = templatefile("${path.module}/inventory.tpl", {
    head_ip = data.digitalocean_droplet.existing_nodes[0].ipv4_address
    com1_ip = data.digitalocean_droplet.existing_nodes[1].ipv4_address
    com2_ip = digitalocean_droplet.com2.ipv4_address
  })
  depends_on = [digitalocean_droplet.com2]
}

output "head_ip" {
  value = data.digitalocean_droplet.existing_nodes[0].ipv4_address
}

output "com1_ip" {
  value = data.digitalocean_droplet.existing_nodes[1].ipv4_address
}

output "com2_ip" {
  value = digitalocean_droplet.com2.ipv4_address
}

output "existing_cluster_ips" {
  value = {
    head = {
      public  = data.digitalocean_droplet.existing_nodes[0].ipv4_address
      private = data.digitalocean_droplet.existing_nodes[0].ipv4_address_private
    }
    com1 = {
      public  = data.digitalocean_droplet.existing_nodes[1].ipv4_address
      private = data.digitalocean_droplet.existing_nodes[1].ipv4_address_private
    }
  }
}

output "com2_details" {
  value = {
    name       = digitalocean_droplet.com2.name
    public_ip  = digitalocean_droplet.com2.ipv4_address
    private_ip = digitalocean_droplet.com2.ipv4_address_private
    status     = digitalocean_droplet.com2.status
  }
}
