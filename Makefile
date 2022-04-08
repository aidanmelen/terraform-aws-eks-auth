NAME = terraform-aws-eks-auth

SHELL := /bin/bash

.PHONY: help all

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build docker dev container
	cd .devcontainer && docker build -f Dockerfile . -t $(NAME)

run: ## Run docker dev container
	docker run -it --rm -v "$$(pwd)":/workspaces/$(NAME) -v ~/.aws:/root/.aws -v ~/.kube:/root/.kube -v ~/.cache/pre-commit:/root/.cache/pre-commit -v ~/.terraform.d/plugins:/root/.terraform.d/plugins --workdir /workspaces/$(NAME) $(NAME) /bin/bash

install: ## Install project
	# terraform
	terraform init
	cd examples/basic && terraform init
	cd examples/complete && terraform init

	# terratest
	go get github.com/gruntwork-io/terratest/modules/terraform
	go mod init test/terraform_basic_test.go

	# pre-commit
	git init
	git add -A
	pre-commit install

lint:  ## Lint with pre-commit
	git add -A
	pre-commit run
	git add -A

tests: test-basic test-complete ## Test with Terratest

test-basic:  ## Test Basic Example
	go test test/terraform_basic_test.go -timeout 45m -v |& tee test/terraform_basic_test.log

test-complete: ## Test Complete Example
	go test test/terraform_complete_test.go -timeout 45m -v |& tee test/terraform_complete_test.log

clean: ## Clean project
	@rm -f .terraform.lock.hcl
	@rm -f examples/basic/.terraform.lock.hcl
	@rm -f examples/complete/.terraform.lock.hcl

	@rm -rf .terraform
	@rm -rf examples/basic/.terraform
	@rm -rf examples/complete/.terraform

	@rm -f go.mod
	@rm -f go.sum
