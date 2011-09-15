module MockedCustomerProfileResponseXml
  def ssl_post(endpoint, data, headers = {})
    %Q{
    <?xml version="1.0" encoding="utf-8"?>
      <createCustomerProfileResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
        <messages>
          <resultCode>Ok</resultCode>
          <message>
            <code>I00001</code>
            <text>Successful.</text>
          </message>
        </messages>
        <customerProfileId>4581836</customerProfileId>
        <customerPaymentProfileIdList />
        <customerShippingAddressIdList />
        <validationDirectResponseList />
        </createCustomerProfileResponse>
    }.strip.gsub(/\s\s+/, ' ').gsub(/>\s+/, '>').gsub(/\s+</,'')
  end
end

module MockedCustomerPaymentProfileResponseXml
  def ssl_post(endpoint, data, headers = {})
    %Q{
    <?xml version="1.0" encoding="utf-8"?>
      <createCustomerPaymentProfileResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
        <messages>
          <resultCode>Ok</resultCode>
          <message>
            <code>I00001</code>
            <text>Successful.</text>
          </message>
        </messages>
        <customerPaymentProfileId>3981842</customerPaymentProfileId>
        </createCustomerPaymentProfileResponse>
    }.strip.gsub(/\s\s+/, ' ').gsub(/>\s+/, '>').gsub(/\s+</,'')
  end
end

module MockedCustomerProfileTransactionResponseXml
  def ssl_post(endpoint, data, headers = {})
    %Q{
    <?xml version="1.0" encoding="utf-8"?>
      <createCustomerProfileTransactionResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
        <messages>
          <resultCode>Ok</resultCode>
          <message>
            <code>I00001</code>
            <text>Successful.</text>
          </message>
        </messages>
        <directResponse>1,1,1,This transaction has been approved.,PA4F54,Y,2162576907,,,200.00,CC,auth_only,,,,,,,,,,,,johny.walker@example.com,,,,,,,,,,,,,,21455FC1A0CA3A414774E8BE35E841AA,,2,,,,,,,,,,,XXXX0027,Visa,,,,,,,,,,,,,,,,</directResponse>
      </createCustomerProfileTransactionResponse>
    }.strip.gsub(/\s\s+/, ' ').gsub(/>\s+/, '>').gsub(/\s+</,'')
  end
end

module ActiveMerchant
  module Billing
    class AuthorizeNetCimMockedGateway < AuthorizeNetCimGateway

      SUCCESS_MESSAGE = "AuthorizeNetCimMocked Gateway: success"
      ERROR_MESSAGE   = "AuthorizeNetCimMocked Gateway: error"
      CUSTOMER_PROFILE_ID   = '53433'
      CUSTOMER_PAYMENT_PROFILE_ID = '6729348'
      AUTHORIZATION_TRANSACTION_ID = '7864578'
      VOID_TRANSACTION_ID = '729310076'

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
        transaction_type = options.fetch(:transaction).fetch(:type)

        case transaction_type
          when :auth_only
            if make_roundtrip
              self.send(:extend, MockedCustomerProfileTransactionResponseXml)
              super
            else
              Response.new(true, SUCCESS_MESSAGE, {'direct_response' => {'transaction_id' => AUTHORIZATION_TRANSACTION_ID }} , {} )
            end

          when :void
            if make_roundtrip
              self.send(:extend, MockedCustomerProfileTransactionResponseXml)
              super
            else
              Response.new(true, SUCCESS_MESSAGE, {'direct_response' => {'transaction_id' => VOID_TRANSACTION_ID }} , {} )
            end

          end
        end

    end
  end
end
