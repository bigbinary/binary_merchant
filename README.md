# BinaryMerchant

It is a payment processing utility tool built on top of [Active Merchant](https://github.com/shopify/active_merchant) .

Currently BinaryMerchant supports <strong>AuthorizeNetGateway</strong> and <strong>AuthorizeNetCimGateway</strong> gateways.

The API provided by Authorize.net CIM could be a bit confusing. Active Merchant has good job of hiding the complexity. However BinaryMerchant makes it even simpler.

## Testing with BinaryMerchant without hitting the server

You have built your application using <strong>AuthorizeNetCimGateway</strong>. Now you want to test your code. Howver you do not want to hit Authorize.net server during tests. Well you can mock the requests with stub . But before that you need to know what params to expect in response. BinaryMerchant has figured all that out for you.

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

Above we configured the gateway. Now let's see a concrete example. Let's say whenver a user record is created we want to create <tt>customer_profile_id</tt> for that record. The code would look something like this.

```
class User < ActiveRecord::Base
  before_create :create_customer_profile_id

  private

  def create_customer_profile_id
   _vault_id, response = *(ADNCIMP.add_user(email: self.email))
   if _vault_id
     self.vault_id = _vault_id
   else
     raise "customer_profile_id could not be created"
   end
  end
end
```

Test for above code would be like

```
describe User do
  context "customer_profile_id" do
    it "without roundtrip" do
      user = Factory(:user).reload
      user.vault_id.should_not be_nil
      user.vault_id.should == ActiveMerchant::Billing::AuthorizeNetCimMockedGateway::CUSTOMER_PROFILE_ID ,
    end
  end
end
```

In the above case the call to gateway is intercepted and a response object is returned.

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
