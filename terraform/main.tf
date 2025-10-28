# Get existing droplets for reference
data "digitalocean_droplet" "existing_nodes" {
  count = 2
  name  = count.index == 0 ? "head" : "com1"
}

# Create com2 droplet - use the SSH key fingerprint
resource "digitalocean_droplet" "com2" {
  name     = "com2"
  image    = var.image
  size     = var.com2_size
  region   = var.region
  ssh_keys = ["32:3c:70:32:75:4f:9d:be:6c:4d:89:da:38:88:c1:d4"]  # Use the fingerprint
  tags     = var.tags

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.private_key_path)
    host        = self.ipv4_address
    timeout     = "10m"
  }

  # Initial setup script
  provisioner "remote-exec" {
    inline = [
      "echo 'Com2 node provisioned successfully'",
      "hostnamectl set-hostname com2",
      "echo 'com2' > /etc/hostname",
      "echo '${data.digitalocean_droplet.existing_nodes[0].ipv4_address_private} head' >> /etc/hosts",
      "echo '${data.digitalocean_droplet.existing_nodes[1].ipv4_address_private} com1' >> /etc/hosts",
      "echo '${self.ipv4_address_private} com2' >> /etc/hosts"
    ]
  }
}

# Generate Ansible inventory file
resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.ini"
  content = templatefile("inventory.tpl", {
    head_public_ip  = data.digitalocean_droplet.existing_nodes[0].ipv4_address
    head_private_ip = data.digitalocean_droplet.existing_nodes[0].ipv4_address_private
    com1_public_ip  = data.digitalocean_droplet.existing_nodes[1].ipv4_address
    com1_private_ip = data.digitalocean_droplet.existing_nodes[1].ipv4_address_private
    com2_public_ip  = digitalocean_droplet.com2.ipv4_address
    com2_private_ip = digitalocean_droplet.com2.ipv4_address_private
  })
  depends_on = [digitalocean_droplet.com2]
}

# Output the results
output "com2_details" {
  description = "Details of the newly created com2 node"
  value = {
    name          = digitalocean_droplet.com2.name
    public_ip     = digitalocean_droplet.com2.ipv4_address
    private_ip    = digitalocean_droplet.com2.ipv4_address_private
    status        = digitalocean_droplet.com2.status
  }
}

output "existing_cluster_ips" {
  description = "IP addresses of existing cluster nodes"
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

output "connection_instructions" {
  description = "Instructions for connecting to com2"
  value = <<EOT

DigitalOcean Cluster Deployment Complete!

New Node Added:
  com2 - Public: ${digitalocean_droplet.com2.ipv4_address} | Private: ${digitalocean_droplet.com2.ipv4_address_private}

Existing Cluster:
  head - Public: ${data.digitalocean_droplet.existing_nodes[0].ipv4_address} | Private: ${data.digitalocean_droplet.existing_nodes[0].ipv4_address_private}
  com1 - Public: ${data.digitalocean_droplet.existing_nodes[1].ipv4_address} | Private: ${data.digitalocean_droplet.existing_nodes[1].ipv4_address_private}

Next Steps:
1. SSH to com2: ssh root@${digitalocean_droplet.com2.ipv4_address}
2. Run Ansible playbook: cd ansible && ansible-playbook -i inventory.ini playbook-com2.yml
3. Verify cluster connectivity

EOT
  depends_on = [digitalocean_droplet.com2]
}

# Generate CI-friendly inventory for GitHub Actions
resource "local_file" "ci_inventory" {
  filename = "../ansible/inventory.ini"
  content = <<EOT
[head]
${data.digitalocean_droplet.existing_nodes[0].ipv4_address_private} ansible_user=clusteradmin ansible_ssh_private_key_file=/tmp/ssh_key ansible_become=yes

[compute]
${data.digitalocean_droplet.existing_nodes[1].ipv4_address_private} ansible_user=clusteradmin ansible_ssh_private_key_file=/tmp/ssh_key ansible_become=yes
${digitalocean_droplet.com2.ipv4_address_private} ansible_user=clusteradmin ansible_ssh_private_key_file=/tmp/ssh_key ansible_become=yes

[all:vars]
ansible_python_interpreter=/usr/bin/python3
private_network=10.106.0.0/20
head_private_ip=${data.digitalocean_droplet.existing_nodes[0].ipv4_address_private}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOT
  depends_on = [digitalocean_droplet.com2]
}
