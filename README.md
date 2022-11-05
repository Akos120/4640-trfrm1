# 4640-trfrm1

Installing Terraform

Create the .env file which holds a variable for your DigitalOcean API token to be used with Terraform.

It should be in the format

Use an environment variable b/c 


Create the main.tf file which first contains basic information of the provider you are using (e.g. DigitalOcean)

```bash
terraform init
```

sets up your working directory to work with your provider

in main.tf add blocks for your ssh key you are using and your digital ocean project

Use the command ```bash terraform validate``` to check your syntax and that everything is fine
