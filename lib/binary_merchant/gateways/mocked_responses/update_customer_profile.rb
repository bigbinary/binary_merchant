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

