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

module MockedCustomerProfileTransactionResponseXmlForAuthorization
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
        <directResponse>1,1,1,This transaction has been approved.,PA4F54,Y,2166026907,,,200.00,CC,auth_only,,,,,,,,,,,,johny.walker@example.com,,,,,,,,,,,,,,21455FC1A0CA3A414774E8BE35E841AA,,2,,,,,,,,,,,XXXX0027,Visa,,,,,,,,,,,,,,,,</directResponse>
      </createCustomerProfileTransactionResponse>
    }.strip.gsub(/\s\s+/, ' ').gsub(/>\s+/, '>').gsub(/\s+</,'')
  end
end

module MockedCustomerProfileTransactionResponseXmlForVoid
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
        <directResponse>1,1,1,This transaction has been approved.,PA4F54,P,2162571957,,,0.00,CC,void,,,,,,,,,,,,,,,,,,,,,,,,,,D3531FE25404EB8DE366E5E2CB569C73,,,,,,,,,,,,,XXXX0027,Visa,,,,,,,,,,,,,,,,</directResponse>
      </createCustomerProfileTransactionResponse>
    }.strip.gsub(/\s\s+/, ' ').gsub(/>\s+/, '>').gsub(/\s+</,'')
  end
end

module MockedCustomerProfileTransactionResponseXmlForRefund
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
        <directResponse>1,1,1,This transaction has been approved.,PA4F54,P,8862571957,,,0.00,CC,refund,,,,,,,,,,,,,,,,,,,,,,,,,,D3531FE25404EB8DE366E5E2CB569C73,,,,,,,,,,,,,XXXX0027,Visa,,,,,,,,,,,,,,,,</directResponse>
      </createCustomerProfileTransactionResponse>
    }.strip.gsub(/\s\s+/, ' ').gsub(/>\s+/, '>').gsub(/\s+</,'')
  end
end

module MockedCustomerProfileTransactionResponseXmlForCapture
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
        <directResponse>1,1,1,This transaction has been approved.,PA4F54,Y,2166026907,,,200.00,CC,auth_only,,,,,,,,,,,,johny.walker@example.com,,,,,,,,,,,,,,21455FC1A0CA3A414774E8BE35E841AA,,2,,,,,,,,,,,XXXX0027,Visa,,,,,,,,,,,,,,,,</directResponse>
      </createCustomerProfileTransactionResponse>
    }.strip.gsub(/\s\s+/, ' ').gsub(/>\s+/, '>').gsub(/\s+</,'')
  end
end

module MockedCustomerUpdateProfileResponseXml
  def ssl_post(endpoint, data, headers = {})
    %Q{
    <?xml version="1.0" encoding="utf-8"?>
      <updateCustomerProfileResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
      <messages>
        <resultCode>Ok</resultCode>
        <message>
          <code>I00001</code>
          <text>Successful.</text>
        </message>
      </messages>
    </updateCustomerProfileResponse>
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
      CAPTURE_TRANSACTION_ID = '729310076'
      REFUND_TRANSACTION_ID = '47776432293'

      attr_accessor :make_roundtrip

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
