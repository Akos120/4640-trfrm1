# 4640-trfrm1

## Installing Terraform

Create the .env file which holds a variable for your DigitalOcean API token to be used with Terraform.

It should be in the format

Use an environment variable b/c 

## Setting Up
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
resource "digitalocean_vpc" "web_vpc" {
  name     = "4640_labs"
  region   = "sfo3"
}
```

