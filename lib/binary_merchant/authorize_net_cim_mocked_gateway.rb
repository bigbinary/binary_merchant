module ActiveMerchant
  module Billing
    class AuthorizeNetCimMockedGateway < AuthorizeNetCimGateway

      SUCCESS_MESSAGE = "AuthorizeNetCimMocked Gateway: success"
      ERROR_MESSAGE   = "AuthorizeNetCimMocked Gateway: error"
      AUTHORIZATION   = '53433'
      CUSTOMER_PAYMENT_PROFILE_ID = '1234'

      # point live_url to test_url so that even accidentally live_url is never used
      self.live_url = self.test_url

      def create_customer_payment_profile(options)
        Response.new(true, SUCCESS_MESSAGE, {:customer_payment_profile_id => CUSTOMER_PAYMENT_PROFILE_ID}, {} )
      end

      def create_customer_profile(options)
        Response.new(true, SUCCESS_MESSAGE, options, {:authorization => AUTHORIZATION} )
      end

      def create_customer_profile_transaction(options)
        Response.new(true, SUCCESS_MESSAGE, {'direct_response' => {'transaction_id' => '123456'}} , {} )
      end

    end
  end
end
