
module ActiveMerchant
  module Billing
    class AuthorizeNetCimMockedGateway < AuthorizeNetCimGateway

      SUCCESS_MESSAGE = "AuthorizeNetCimMocked Gateway: success"
      ERROR_MESSAGE   = "AuthorizeNetCimMocked Gateway: error"
      CUSTOMER_PROFILE_ID   = '53433'
      CUSTOMER_PAYMENT_PROFILE_ID = '6729348'
      AUTHORIZATION_TRANSACTION_ID = '7864578'
      VOID_TRANSACTION_ID = '729310076'
      CAPTURE_TRANSACTION_ID = '729310076'
      REFUND_TRANSACTION_ID = '47776432293'

      attr_accessor :make_roundtrip

      def delete_customer_payment_profile(options)
        Response.new(true, SUCCESS_MESSAGE, options, { } )
      end

      def delete_customer_profile(options)
        if make_roundtrip
          self.send(:extend, MockedCustomerDeleteProfileResponseXml)
          super
        else
          Response.new(true, SUCCESS_MESSAGE, options, { } )
        end
      end

      def update_customer_profile(options)
        if make_roundtrip
          self.send(:extend, MockedCustomerUpdateProfileResponseXml)
          super
        else
          Response.new(true, SUCCESS_MESSAGE, options, { } )
        end
      end

      def create_customer_profile(options)
        if make_roundtrip
          self.send(:extend, MockedCreateCustomerProfileResponseXml)
          super
        else
          Response.new(true, SUCCESS_MESSAGE, options, {:authorization => CUSTOMER_PROFILE_ID } )
        end
      end

      def create_customer_payment_profile(options)
        if make_roundtrip
          self.send(:extend, MockedCreateCustomerPaymentProfileResponseXml)
          super
        else
          Response.new(true, SUCCESS_MESSAGE, {:customer_payment_profile_id => CUSTOMER_PAYMENT_PROFILE_ID}, {} )
        end
      end

      def create_customer_profile_transaction(options)
        transaction_type = options.fetch(:transaction).fetch(:type)

        case transaction_type
          when :auth_only
            if make_roundtrip
              self.send(:extend, MockedCustomerProfileTransactionResponseXmlForAuthorization)
              super
            else
              Response.new(true, SUCCESS_MESSAGE, {'direct_response' => {'transaction_id' => AUTHORIZATION_TRANSACTION_ID }} , {} )
            end

          when :void
            if make_roundtrip
              self.send(:extend, MockedCustomerProfileTransactionResponseXmlForVoid)
              super
            else
              Response.new(true, SUCCESS_MESSAGE, {'direct_response' => {'transaction_id' => VOID_TRANSACTION_ID }} , {} )
            end

          when :refund
            if make_roundtrip
              self.send(:extend, MockedCustomerProfileTransactionResponseXmlForRefund)
              super
            else
              Response.new(true, SUCCESS_MESSAGE, {'direct_response' => {'transaction_id' => REFUND_TRANSACTION_ID }} , {} )
            end

          when :prior_auth_capture
            if make_roundtrip
              self.send(:extend, MockedCustomerProfileTransactionResponseXmlForCapture)
              super
            else
              Response.new(true, SUCCESS_MESSAGE, {'direct_response' => {'transaction_id' => CAPTURE_TRANSACTION_ID }} , {} )
            end




          end
        end

    end
  end
end
