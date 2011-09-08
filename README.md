# BinaryMerchant

It is a payment processing utility tool built on top of [Active Merchant](https://github.com/shopify/active_merchant) .

The API provided by Authorize.net CIM is could be confusing. Active Merchant has good support for Authorize.net CIM gateway . However the API remains a little complex. This gem simplifies the API a lot.

## Testing with BinaryMerchant

You have built your application using <tt>AuthorizeNetCimGateway</tt>. Now you want to test your code. Howver you do not want to hit Authorize.net server during tests. Some people try to use <tt>BogusGateway</tt> that comes with Active Merchant. However <tt>BogusGateway</tt> does not have all the methods that can be called on <tt>AuthorizeNetCimGateway</tt>.

BinaryMerchant can help .

This gem provides a gateway called <tt>AuthorizeNetCimMockedGateway</tt> and this gateway returns predefined responses and does not hit Authorize.net server.

Put the following code at <tt>config/intializers/binary_merchant.rb</tt> and now in test you are using mocked gateway.

```ruby
login = <login id provided by authorize.net>
password = <transaction key provided by authorize.net>

ActiveMerchant::Billing::Base.mode = Rails.env.production? ? :production : :test

gateway_klass = if Rails.env.test?
  ActiveMerchant::Billing::AuthorizeNetCimMockedGateway
else
  ActiveMerchant::Billing::AuthorizeNetCimGateway
end

gateway_klass.logger = Rails.logger

::GATEWAYP = GatewayProcessor.new( gateway_klass.new( login: login, password: transaction_key ) )
```

## Logging of xml in development

If you look at previous snippet of code you will see following line

```ruby
gateway_klass.logger = Rails.logger
```
Because of that line in development mode you will see the xml request that is sent to Authorize.net by Active Merchant in log. Similarly the response sent by Authorize.net will also be seen in the log.
