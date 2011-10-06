require "binary_merchant/version"

module BinaryMerchant
  extend ActiveSupport::Autoload

  autoload :Gateway
  autoload :AuthorizeNetGateway, 'binary_merchant/gateways/authorize_net'
  autoload :AuthorizeNetCimGateway, 'binary_merchant/gateways/authorize_net_cim'

  autoload :CyberSourceGateway, 'binary_merchant/gateways/cyber_source'
end

require "binary_merchant/requires"

require "binary_merchant/gateways/authorize_net_mocked"
require "binary_merchant/gateways/authorize_net_cim_mocked"
require "binary_merchant/gateways/cyber_source_mocked"

require 'binary_merchant/gateways/mocked_responses/create_customer_profile'
require 'binary_merchant/gateways/mocked_responses/create_customer_payment_profile'
require 'binary_merchant/gateways/mocked_responses/customer_profile_transaction_response_for_authorization'
require 'binary_merchant/gateways/mocked_responses/customer_profile_transaction_response_for_void'
require 'binary_merchant/gateways/mocked_responses/customer_profile_transaction_response_for_refund'
require 'binary_merchant/gateways/mocked_responses/customer_profile_transaction_response_for_capture'
require 'binary_merchant/gateways/mocked_responses/update_customer_profile'
require 'binary_merchant/gateways/mocked_responses/delete_customer_profile'

