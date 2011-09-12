module MockedCustomerProfileResponseXml
  def ssl_post(endpoint, data, headers = {})
    %Q{<?xml version="1.0" encoding="utf-8"?><createCustomerProfileResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd"><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><customerProfileId>4581836</customerProfileId><customerPaymentProfileIdList /><customerShippingAddressIdList /><validationDirectResponseList /></createCustomerProfileResponse>}
  end
end

module MockedCustomerPaymentProfileResponseXml
  def ssl_post(endpoint, data, headers = {})
    %Q{<?xml version="1.0" encoding="utf-8"?><createCustomerPaymentProfileResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd"><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><customerPaymentProfileId>3981842</customerPaymentProfileId></createCustomerPaymentProfileResponse>}
  end
end

module ActiveMerchant
  module Billing
    class AuthorizeNetCimMockedGateway < AuthorizeNetCimGateway

      SUCCESS_MESSAGE = "AuthorizeNetCimMocked Gateway: success"
      ERROR_MESSAGE   = "AuthorizeNetCimMocked Gateway: error"
      CUSTOMER_PROFILE_ID   = '53433'
      CUSTOMER_PAYMENT_PROFILE_ID = '1234'

      attr_accessor :make_roundtrip

      def create_customer_profile(options)
        if make_roundtrip
          self.send(:extend, MockedCustomerProfileResponseXml)
          super
        else
          Response.new(true, SUCCESS_MESSAGE, options, {:authorization => CUSTOMER_PROFILE_ID } )
        end
      end

      def create_customer_payment_profile(options)
        if make_roundtrip
          self.send(:extend, MockedCustomerPaymentProfileResponseXml)
          super
        else
          Response.new(true, SUCCESS_MESSAGE, {:customer_payment_profile_id => CUSTOMER_PAYMENT_PROFILE_ID}, {} )
        end
      end

      def create_customer_profile_transaction(options)
        Response.new(true, SUCCESS_MESSAGE, {'direct_response' => {'transaction_id' => '123456'}} , {} )
      end

    end
  end
end
