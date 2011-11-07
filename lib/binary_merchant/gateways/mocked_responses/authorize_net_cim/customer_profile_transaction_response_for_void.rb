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

