require "binary_merchant/version"

module BinaryMerchant
  extend ActiveSupport::Autoload

  autoload :Gateway
  autoload :AuthorizeNetGateway, 'binary_merchant/gateways/authorize_net'
  autoload :AuthorizeNetCimGateway, 'binary_merchant/gateways/authorize_net_cim'
end

require "binary_merchant/gateways/authorize_net_mocked"
require "binary_merchant/gateways/authorize_net_cim_mocked"
