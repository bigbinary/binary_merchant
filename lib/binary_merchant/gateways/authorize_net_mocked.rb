module ActiveMerchant
  module Billing
    class AuthorizeNetMockedGateway < AuthorizeNetGateway

      SUCCESS_MESSAGE = "AuthorizeNetMocked Gateway: success"
      ERROR_MESSAGE   = "AuthorizeNetMocked Gateway: error"

      attr_accessor :make_roundtrip

      def authorize(amount, creditcard, options = {})
        Response.new(true, SUCCESS_MESSAGE, {'transaction_id' => '1234567890'} , {} )
      end

      def capture(amount, transaction_id, options = {})
        Response.new(true, SUCCESS_MESSAGE, {'transaction_id' => '1234567891'} , {} )
      end

      def purchase(amount, creditcard, options = {})
        Response.new(true, SUCCESS_MESSAGE, {'transaction_id' => '1234567892'} , {} )
      end

      def void(transaction_id, options = {})
        Response.new(true, SUCCESS_MESSAGE, {'transaction_id' => '1234567893'} , {} )
      end

      def refund(amount, transaction_id, options = {})
        Response.new(true, SUCCESS_MESSAGE, {'transaction_id' => '1234567894'} , {} )
      end

    end
  end
end
