# BinaryMerchant

It is a payment processing utility tool built on top of [Active Merchant](https://github.com/shopify/active_merchant) .

The API provided by Authorize.net CIM is could be confusing. Active Merchant has good support for Authorize.net CIM gateway . However the API remains a little complex. This gem simplifies the API a lot.

## Testing with BinaryMerchant

This gem also simplifies testing of application built using <tt>AuthorizeNetCimGateway</tt> . In the test environment use the mocked gateway as given below. Put the following code at <tt>config/intializers/binary_merchant.rb</tt> .

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
