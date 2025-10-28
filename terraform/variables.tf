# DigitalOcean Authentication
variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

# Deployment Configuration
variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "lon1"
}

variable "cluster_name" {
  description = "Cluster name prefix for resources"
  type        = string
  default     = "student-cluster"
}

# Instance Configuration
variable "com2_size" {
  description = "Droplet size for com2"
  type        = string
  default     = "s-2vcpu-4gb"  # Matches your com1 specs
}

variable "image" {
  description = "Droplet image"
  type        = string
  default     = "rockylinux-9-x64"
}

# SSH Configuration
variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
  default     = "~/.ssh/id_ed25519"
}

# Tags
variable "tags" {
  description = "Tags to apply to resources"
  type        = list(string)
  default     = ["student-cluster", "hpc", "com2", "automated"]
}
