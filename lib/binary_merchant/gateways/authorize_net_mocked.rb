module ActiveMerchant
  module Billing
    class AuthorizeNetMockedGateway < AuthorizeNetGateway

      SUCCESS_MESSAGE = "AuthorizeNetMocked Gateway: success"
      ERROR_MESSAGE   = "AuthorizeNetMocked Gateway: error"

      attr_accessor :make_roundtrip

      def authorize(amount, creditcard, extra = {})
        Response.new(true, SUCCESS_MESSAGE, {'transaction_id' => '123456'} , {} )
      end

    end
  end
end
