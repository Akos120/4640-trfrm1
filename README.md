# 4640-trfrm1

## Installing Terraform

Create the .env file which holds a variable for your DigitalOcean API token to be used with Terraform.

It should be in the format

Use an environment variable b/c 

## Setting Up
In DigitalOcean, make sure to setup a Personal Access Token, 
Create the main.tf file which first contains basic information of the provider you are using (e.g. DigitalOcean)

```bash
terraform init
```

sets up your working directory to work with your provider

in main.tf add blocks for your ssh key you are using and your digital ocean project
```terraform
data "digitalocean_ssh_key" "ssh_key" {
  name = "4640_ssh"
}

data "digitalocean_project" "lab_project" {
  name = "4640-wk5"
}
```

Use the command ```bash terraform validate``` to check your syntax and that everything is fine

terraform plan will show you an overview of what you're making without actually creating the resources.


Create all resource blocks needed to setup a web server
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

Create a droplet attaching the resources you specified before
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

Make sure to keep validating and planning your code as you work. terraform fmt will format

Attach the resources to your project
```terraform
resource "digitalocean_project_resources" "project_attach" {
  project = data.digitalocean_project.lab_project.id
  resources = [
    digitalocean_droplet.web.urn
  ]
}
```

write an output

build your infrastrure with
```bash
terraform apply
```

In your DigitalOcean account, you should be able to the newly create droplets, vpc, etc. Your droplet should have the same IP address as what you outputted.

You can also ssh into the droplet

```bash
terraform show
```
To view information on your resources

You can add more droplets by specifying in the droplet resource

after changes, can do terraform apply to rebuild 

to get rid of everything terraform destroy
theres no undo
