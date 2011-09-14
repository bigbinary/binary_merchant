# BinaryMerchant

It is a payment processing utility tool built on top of [Active Merchant](https://github.com/shopify/active_merchant) .

Currently BinaryMerchant supports <strong>AuthorizeNetGateway</strong> and <strong>AuthorizeNetCimGateway</strong> gateways.

The API provided by Authorize.net CIM could be a bit confusing. Active Merchant has good support for Authorize.net CIM gateway . However the API remains a little complex. This gem simplifies the API a lot.

## Testing with BinaryMerchant without hitting the server

You have built your application using <strong>AuthorizeNetCimGateway</strong>. Now you want to test your code. Howver you do not want to hit Authorize.net server during tests. Some people try to use <tt>BogusGateway</tt> that comes with Active Merchant. However <tt>BogusGateway</tt> does not have all the methods that can be called on <tt>AuthorizeNetCimGateway</tt>.

BinaryMerchant can help .

This gem provides a gateway called <tt>AuthorizeNetCimMockedGateway</tt> and this gateway returns predefined responses and does not hit Authorize.net server.

Put the following code at <tt>config/intializers/binary_merchant.rb</tt> and now in test you are using mocked gateway.

```ruby
credentials = { login: login_id_provided_by_authorize_dot_net,
                password: transaction_key_provided_by_authorize_net }

ActiveMerchant::Billing::Base.mode = Rails.env.production? ? :production : :test

gateway_klass = if Rails.env.test?
  ActiveMerchant::Billing::AuthorizeNetCimMockedGateway
else
  ActiveMerchant::Billing::AuthorizeNetCimGateway
end

gateway_klass.logger = Rails.logger

::ADNCIMP = BinaryMerchant::AuthorizeNetCimGateway.new( gateway_klass.new(credentials) )
```

Now you can go about doing your testing. All calls to gateway would be intercepted and a response object will be returned.

## Testing with BinaryMerchnat with full roundtrip

Testing using above mechanism works. However it has one issue. ActiveMerchant does a number of validation checks while building the xml. In the above case xml is never built. To do exhaustive testing we would like xml to be built. Howver that xml should not be sent to Authorize.net .  Here is how you can do full roundtrip testing. The code example is taken from a minitest but it can easily be modified if you are using rspec.

```ruby
class GatewayTest < ActiveSupport::TestCase

  def setup
    ADNCIMP.gateway.make_roundtrip = false
  end

  def test_authorize_net_returns_customer_profile_id_without_roundtrip
    user = Factory(:user).reload
    assert user.vault_id, "customer profile id should not be nil"
    assert_equal "53433", user.vault_id
  end

  def test_authorize_net_returns_customer_profile_id_with_roundtrip
    ADNCIMP.gateway.make_roundtrip = true
    user = Factory(:user).reload
    assert user.vault_id, "customer profile id should not be nil"
    assert_equal "4581836", user.vault_id
  end

end
```

By default <tt>make_roundtrip</tt> value is false.

## Logging of xml in development

If you look at previous snippet of code you will see following line

```ruby
gateway_klass.logger = Rails.logger
```
Because of that line in development mode you will see the xml request that is sent to Authorize.net by Active Merchant in log. Similarly the response sent by Authorize.net will also be seen in the log.
