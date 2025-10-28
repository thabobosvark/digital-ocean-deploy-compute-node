variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "lon1"
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
  default     = "student-cluster"
}

variable "com2_size" {
  description = "Size for com2 node"
  type        = string
  default     = "s-2vcpu-4gb"
}

variable "image" {
  description = "Droplet image"
  type        = string
  default     = "rockylinux-9-x64"
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}

variable "tags" {
  description = "Tags for droplets"
  type        = list(string)
  default     = ["github-actions", "hpc-cluster", "automated"]
}

variable "existing_droplet_names" {
  description = "Names of existing droplets (head and com1)"
  type        = list(string)
  default     = ["head", "com1"]
}
