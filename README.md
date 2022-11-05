# 4640-trfrm1
These are a set of instructions on installing and basic setup of Terraform on a Linux system using DigitalOcean

## Installing Terraform
1. Install Terraform by downloading the binary for your OS from: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
  - for Linux install the AMD64 version

2. Unzip the downloaded folder
3. Copy these so it is on your path
  - Put it into your bin directory ```bash cp <unzipped terraform binary> ~/bin```

4. Your .profile file should already have a path to your bin directory.
5. Source this file ```bash source .profile```


## DigitalOcean Setup
1. Create a project
2. Create a Personal Access Token and save it
3. Create an SSH key


## Basic Terraform
1. Create a working directory
2. Create a .env file which will hold a variable for your DigitalOcean Personal Access Token. This will be used with Terraform
```bash
export TF_VAR_do_token=<Your Personal Access Token>
```
3. source it ```bash source .env```
4. Create the main.tf file which will contain all the information you are going to provide to setup an infrastructure
5. Start with the basic information on the provider you are using (e.g. DigitalOcean)
```terraform
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}
```
6. ```bash terraform init``` will set up your working directory with the files needed to work with your provider

7. In main.tf we can now add our data blocks to use our SSH key and DigitalOcean project. The name variables should be the same as what you named your ssh key and project
```terraform
data "digitalocean_ssh_key" "ssh_key" {
  name = "4640_ssh"
}

data "digitalocean_project" "lab_project" {
  name = "4640-wk5"
}
```
8. Use the command ```bash terraform validate``` to check your syntax and structure
```bash terraform fmt``` to format your main.tf file
```bash terraform plan``` to show an overview of what you are making without acutally creating the resources.

9. Create resource blocks for adding tags and vpc:
  - tags
 ```terraform
 resource "digitalocean_tag" "do_tag" {
  name = "Web"
}
```
  -  vpc
```terraform
resource "digitalocean_vpc" "webvpc" {
  name     = "web_labs"
  region   = "sfo3"
}
```

10. Create a droplet attaching the resources you specified before
```terraform
resource "digitalocean_droplet" "web" {
  image    = "rockylinux-9-x64"
  name     = "web-1"
  region   = "sfo3"
  size     = "s-1vcpu-512mb-10gb"
  tags     = [digitalocean_tag.do_tag.id]
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
  vpc_uuid = digitalocean_vpc.web_vpc.id
}
```

*Make sure to keep validating and planning your code as you work

11. Attach the resources to your project
```terraform
resource "digitalocean_project_resources" "project_attach" {
  project = data.digitalocean_project.lab_project.id
  resources = [
    digitalocean_droplet.web.urn
  ]
}
```

12. You can write an output
```terraform
output "server_ip" {
  value   =  digitalocean_droplet.web.ipv4_address
}
```

13. Build your infrastrure with
```bash
terraform apply
```

In your DigitalOcean account, you should be able to the newly create droplets, vpc, etc. Your droplet should have the same IP address as what you outputted.


To view information on your resources

```bash
terraform show
```

You can continue to adjust and make changes to your main.tf. No need to pull down your resources, doing ```bash terraform apply``` will rebuild everything with the changes 

To get rid of everything ```bash terraform destroy```
