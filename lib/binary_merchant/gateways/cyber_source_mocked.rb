module ActiveMerchant
  module Billing
    class CyberSourceMockedGateway < AuthorizeNetCimGateway

      SUCCESS_MESSAGE = "CyberSourceMocked Gateway: success"
      ERROR_MESSAGE   = "CyberSourceMocked Gateway: error"

      attr_accessor :make_roundtrip

      def authorize(amount, creditcard, extra = {})
        Response.new(true, SUCCESS_MESSAGE, {'requestID' => '97535853'} , {} )
      end

    end
  end
end

