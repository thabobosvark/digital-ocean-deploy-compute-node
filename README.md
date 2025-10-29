# Digital Ocean Deploy Compute Node

A simple Terraform project to automate the deployment of compute nodes on Digital Ocean.

## Quick Start

### Prerequisites
- Digital Ocean account
- Digital Ocean API token
- Terraform installed

### Deployment

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/digital-ocean-deploy-compute-node.git
   cd digital-ocean-deploy-compute-node
   ```

2. **Configure your Digital Ocean API token**
   ```bash
   export DIGITALOCEAN_TOKEN="your_api_token_here"
   ```

3. **Deploy the infrastructure**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Project Structure
```
├── main.tf          # Main Terraform configuration
├── variables.tf     # Variable definitions
├── outputs.tf       # Output values
└── README.md        # This file
```

## Features
- Automated Droplet deployment
- SSH key configuration
- Basic security settings
- Cost-effective compute nodes
