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

data "digitalocean_ssh_key" "ssh_key" {
  name = "4640_ssh"
}

data "digitalocean_project" "lab_project" {
  name = "4640-wk5"
}

# Create a new tag
resource "digitalocean_tag" "do_tag" {
  name = "Web"
}

# Create a new vpc
resource "digitalocean_vpc" "web_vpc" {
  name   = "web"
  region = "sfo3"
}

# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "web" {
  image    = "rockylinux-9-x64"
  name     = "web-1"
  region   = "sfo3"
  size     = "s-1vcpu-512mb-10gb"
  tags     = [digitalocean_tag.do_tag.id]
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
  vpc_uuid = digitalocean_vpc.web_vpc.id
}

# add new web-1 droplet to existing 4640-wk5 project
resource "digitalocean_project_resources" "project_attach" {
  project = data.digitalocean_project.lab_project.id
  resources = [
    digitalocean_droplet.web.urn
  ]
}

output "server_ip" {
  value   =  digitalocean_droplet.web.ipv4_address
}
