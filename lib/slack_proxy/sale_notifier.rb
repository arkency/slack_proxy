require 'slack-notifier'

module SlackProxy
  class SaleNotifier
    def initialize(slack_webhook_url, slack_username)
      @slack_webhook_url = slack_webhook_url
      @slack_username    = slack_username
    end

    def call(env)
      params     = Rack::Request.new(env).params
      money      = params.fetch('mc_gross')
      code       = params.fetch('coupon_code')
      email      = params.fetch('payer_email')
      given_name = params.fetch_values('first_name', 'last_name').join(' ')
      items      = params.values_at('item_name1', 'item_name2', 'item_name3', 'item_name4').compact

      send_message(money, given_name, email, items, code)
      render_nothing
    end

    private
    attr_reader :slack_webhook_url, :slack_username

    def render_nothing
      Rack::Response.new
    end

    def send_message(money, given_name, email, items, code)
      notifier = Slack::Notifier.new(slack_webhook_url, {
        username: slack_username,
        icon_emoji: ":panda_face:",
        attachments: [{
          fallback: "+#{money}$",
          text: "+#{money}$",
          color: 'good'
        }]
      })
      main_message = "#{given_name} (#{email}) bought #{items.join(", ")}"
      main_message << " with the following code: #{code}" unless code.empty?
      notifier.ping(main_message)
    end
  end
end
