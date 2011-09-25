# BinaryMerchant

It is a payment processing utility tool built on top of [Active Merchant](https://github.com/shopify/active_merchant) .

Currently BinaryMerchant supports <strong>AuthorizeNetGateway</strong> and <strong>AuthorizeNetCimGateway</strong> gateways.

The API provided by Authorize.net CIM could be a bit confusing. Active Merchant has good job of hiding the complexity. However BinaryMerchant makes it even simpler.

## Show me an example of how BinaryMerchant is simpler than ActiveMerchant

Let's say you are making an authorization request with Authorize.net using <tt>AuthorizeNetCimGateway</tt> . Using ActiveMechant your code will look like this.

```ruby
options = { transaction: { type: :auth_only, amount: amount,
                           customer_profile_id: customer_profile_id,
                           customer_payment_profile_id: customer_payment_profile_id }}
response = gateway.create_customer_profile_transaction(options)
if response.success?
  transaction_id = response.params['direct_response']['transaction_id']
else
  transaction_id = nil
end
```

In the above case method named <tt>create_customer_profile_transaction</tt> was invoked. Also when you get the response object you
need to do <tt>response.params['direct_response']['transaction_id']</tt> .

With BinaryMerchant above could could be written as

```ruby
options = {amount: amount, customer_profile_id: customer_profile_id, customer_payment_id: customer_payment_id}
transaction_id, response = *gateway.authorize(options)
```

In the above case you are calling a method called <tt>authorize</tt> which is much better to look at than a method named <tt>create_customer_profile_transaction</tt>. If the authorization was a success then <tt>transaction_id</tt> will have a value. If authorization fails then transaction_id will be nil.

## Testing with BinaryMerchant without hitting the Authorize.net server

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
      user = Factory(:user)
      user.vault_id.should_not be_nil
      user.vault_id.should == ActiveMerchant::Billing::AuthorizeNetCimMockedGateway::CUSTOMER_PROFILE_ID
    end
  end
end
```

In the above case the call to gateway is intercepted and a response object is returned.

## Testing with BinaryMerchnat with full roundtrip

Testing using above mechanism works. However it has one issue. ActiveMerchant does a number of validation checks while building the xml. In the above case xml is never built. To do exhaustive testing we would like xml to be built. Howver that xml should not be sent to Authorize.net .  Here is how you can do full roundtrip testing.

```
describe User do
  before do
    ADNCIMP.gateway.make_roundtrip = false
  end
  context "customer_profile_id" do
    it "with roundtrip" do
      ADNCIMP.gateway.make_roundtrip = true
      user = Factory(:user)
      user.vault_id.should_not be_nil
      user.vault_id.should == "4581836"
    end
    it "without roundtrip" do
      user = Factory(:user)
      user.vault_id.should_not be_nil
      user.vault_id.should == ActiveMerchant::Billing::AuthorizeNetCimMockedGateway::CUSTOMER_PROFILE_ID
    end
  end
end
```

By default <tt>make_roundtrip</tt> value is false.

## Strengthen validations

ActiveMerchant has validations to ensure that needed require fields are passed. For example when update the customer profile using <tt>AuthorizeNetCimGateway</tt> the method should look like this

```ruby
gateway.update_customer_profile({customer_profile_id: '2358805854', email: 'newemail@example.com'})
```

In the above code if you forget to pass the key <tt>customer_profile_id</tt> then ActiveMerchant will raise an error indicating that key <tt>customer_profile_id</tt> is required.

However if you pass the value <tt>nil</tt> for key <tt>customer_profile_id</tt> then ActiveMerchant will not complain during validations. However the code fails somewhere deep down and I had to spend some time debugging it. BinaryMerchant strenghtenes that validations by ensuring that for every required key the value passed must also be not nil.

## Logging of xml in development

If you look at previous snippet of code you will see following line

```ruby
gateway_klass.logger = Rails.logger
```
Because of that line in development mode you will see the xml request that is sent to Authorize.net by Active Merchant in log. Similarly the response sent by Authorize.net will also be seen in the log.


