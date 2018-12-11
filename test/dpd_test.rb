require 'test_helper'

class DpdTest < MiniTest::Test
  include Rack::Test::Methods

  cover 'SlackProxy::SaleNotifier*'

  def test_dpd_proxies_1_item_with_code_to_slack
    payload = JSON.dump({
      text: "Foo Bar (foo@example.com) bought Async/Remote with the following code: BLACKFRIDAY2015",
      username: "Sale Panda",
      icon_emoji: ":panda_face:",
      attachments: [
        {
          fallback: "+$29.40$",
          text: "+$29.40$",
          color: "good"
        }
      ]
    })
    stub_request(:post, expected_url)
      .with(body: expected_body(payload), headers: expected_headers)
      .to_return(status: 200, body: "", headers: {})

    post "/", {
      item_name1: "Async/Remote",
      mc_gross: "$29.40",
      coupon_code: "BLACKFRIDAY2015",
      payer_email: "foo@example.com",
      first_name: "Foo",
      last_name: "Bar"
    }

    assert_requested(:post, expected_url, body: expected_body(payload), headers: expected_headers)
    assert_equal last_response.status, 200
  end

  def test_dpd_proxies_2_items_without_code_to_slack
    payload = JSON.dump({
      text: "Foo Bar (foo@example.com) bought Async/Remote, blogging",
      username: "Sale Panda",
      icon_emoji: ":panda_face:",
      attachments: [
        {
          fallback: "+$49.00$",
          text: "+$49.00$",
          color: "good"
        }
      ]
    })
    stub_request(:post, expected_url)
      .with(body: expected_body(payload), headers: expected_headers)
      .to_return(status: 200, body: "", headers: {})

    post "/", {
      item_name1: "Async/Remote",
      item_name2: "blogging",
      mc_gross: "$49.00",
      coupon_code: "",
      payer_email: "foo@example.com",
      first_name: "Foo",
      last_name: "Bar"
    }

    assert_requested(:post, expected_url, body: expected_body(payload), headers: expected_headers)
    assert_equal last_response.status, 200
  end

  def test_dpd_proxies_4_items_to_slack
    payload = JSON.dump({
      text: "Foo Bar (foo@example.com) bought Async/Remote, fearless, blogging, RbE with the following code: NEWSLETTER",
      username: "Sale Panda",
      icon_emoji: ":panda_face:",
      attachments: [
        {
          fallback: "+$49.00$",
          text: "+$49.00$",
          color: "good"
        }
      ]
    })
    stub_request(:post, expected_url)
      .with(body: expected_body(payload), headers: expected_headers)
      .to_return(status: 200, body: "", headers: {})

    post "/", {
      item_name1: "Async/Remote",
      item_name2: "fearless",
      item_name3: "blogging",
      item_name4: "RbE",
      mc_gross: "$49.00",
      coupon_code: "NEWSLETTER",
      payer_email: "foo@example.com",
      first_name: "Foo",
      last_name: "Bar"
    }

    assert_requested(:post, expected_url, body: expected_body(payload), headers: expected_headers)
    assert_equal last_response.status, 200
  end

  private

  def expected_body(payload)
    {
      "payload" => payload
    }
  end

  def expected_url
    "https://hooks.slack.com/services/fake"
  end

  def expected_headers
    {
      'Accept' => '*/*',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type' => 'application/x-www-form-urlencoded',
      'User-Agent' => 'Ruby'
    }
  end

  def app
    Rack::Lint.new(SlackProxy::SaleNotifier.new('https://hooks.slack.com/services/fake', 'Sale Panda'))
  end
end
