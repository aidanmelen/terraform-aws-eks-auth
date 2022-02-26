# Terraform Complete Example

This folder contains the the "complete" example of how to run this module.

## Running this module manually

1. Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.
2. Run `terraform init`.
3. Run `terraform plan`.
4. Run `terraform apply`.
5. When you're done, run `terraform destroy`.

## Running automated tests against this module

1. Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.
1. Install [Golang](https://golang.org/) and make sure this code is checked out into your `GOPATH`.
1. `cd test`
1. `go test terraform_complete_test.go -v`
