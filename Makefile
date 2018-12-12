S3_BUCKET  ?= serverless-getdpd-slack
STACK_NAME ?= $(S3_BUCKET)

install:
	-rm -rf vendor/
	@bundle install --no-deployment --with test

serve: ## Serve app at http://localhost:9292
	@bundle exec rackup

test: ## Run unit tests
	@bundle exec ruby -Ilib -Itest test/dpd_test.rb

mutate: ## Run mutation tests
	@bundle exec mutant --include lib --include test --require 'slack_proxy' --use minitest -- 'SlackProxy*'

deploy: install-deployment sam-package sam-deploy ## Deploy to AWS Lambda

install-deployment:
	@bundle install --deployment --without test

sam-package:
	@sam package \
		--template-file template.yaml \
		--output-template-file serverless-output.yaml \
		--s3-bucket $(S3_BUCKET)

sam-deploy:
	@sam deploy \
		--template-file serverless-output.yaml \
		--stack-name  $(STACK_NAME) \
		--capabilities CAPABILITY_IAM

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: serve test help
.DEFAULT_GOAL := help
