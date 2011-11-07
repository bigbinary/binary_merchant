module BinaryMerchant

  class Gateway

    attr_reader :gateway

    def initialize(*args)
      @gateway.class.logger = @logger if @logger
    end

    def self.logger=(_logger)
      @logger = _logger
      gateway.class.logger = @logger if gateway
    end

    def method_missing(method, *args, &block)
      gateway.send(method, *args, &block)
    end

  end
end
