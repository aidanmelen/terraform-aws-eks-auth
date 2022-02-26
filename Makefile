NAME = terraform-aws-eks-auth
VERSION = $(shell poetry version -s)

SHELL := /bin/bash

.PHONY: help all

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build docker image
	docker build -f Dockerfile.dev . -t $(NAME)

dev: ## Run docker dev container
	docker run -it --rm -v "$$(pwd)":/module -v ~/.aws:/root/.aws -v ~/.cache/pre-commit:/root/.cache/pre-commit --workdir /module $(NAME) /bin/bash

install: ## Install pre-commit
	terraform init
	cd examples/basic && terraform init && cd ../..
	cd examples/complete && terraform init && cd ../..
	git init
	git add -A
	pre-commit install

lint: # Lint with pre-commit
	docker run -it --rm -v "$$(pwd)":/module -v ~/.cache/pre-commit:/root/.cache/pre-commit --workdir /module $(NAME) pre-commit run --all && git add *

test: test-basic test-complete ## Test with Terratest

test-basic:  ## Test Basic Example
	go get github.com/gruntwork-io/terratest/modules/terraform
	go test test/terraform_basic_test.go

test-complete: ## Test Basic Example
	go get github.com/gruntwork-io/terratest/modules/terraform
	go test test/terraform_complete_test.go

tests: lint tests ## Lint and Test
