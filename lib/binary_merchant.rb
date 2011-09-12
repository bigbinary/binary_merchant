require "binary_merchant/version"
require "binary_merchant/adn_gateway_processor"
require "binary_merchant/adn_cim_gateway_processor"
require "binary_merchant/authorize_net_cim_mocked_gateway"

module BinaryMerchant
  class GatewayProcessorException < StandardError
  end
end
