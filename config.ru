require 'slack_proxy'

run SlackProxy::SaleNotifier.new(ENV['SLACK_WEBHOOK_URL'], ENV['SLACK_USERNAME'])