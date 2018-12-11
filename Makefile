serve: ## Serve app at http://localhost:9292
	@bundle exec rackup -Ilib

test: ## Run unit tests
	@bundle exec ruby -Ilib -Itest test/dpd_test.rb

mutate: ## Run mutation tests
	@bundle exec mutant --include lib --include test --require 'slack_proxy' --use minitest -- 'SlackProxy*'

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: serve test help
.DEFAULT_GOAL := help
