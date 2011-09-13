module BinaryMerchant #:nodoc:

  class GatewayException < StandardError
  end

  class Gateway

    attr_reader :gateway

    def initialize(*args)
      @gateway.class.logger = @logger if @logger
    end

    def self.logger=(_logger)
      @logger = _logger
      @gateway.class.logger = @logger if @gateway
    end

  end
end
