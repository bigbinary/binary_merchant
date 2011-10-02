module BinaryMerchant #:nodoc:
  class CyberSourceGateway < Gateway

    def initialize(_gateway)
      @gateway = _gateway
      super
    end

    def authorize(options)
      response = gateway.authorize(options.fetch(:amount),
                                   options.fetch(:creditcard),
                                   {order_id: options.fetch(:order_id),
                                    email: options.fetch(:email),
                                    billing_address: options.fetch(:address)})
      transaction_id = response.success? ? response.params['requestID'] : nil
      [transaction_id, response]
    end

    def capture(options)
      response = gateway.authorize(options.fetch(:amount),
                                   options.fetch(:creditcard),
                                   {order_id: options.fetch(:order_id),
                                    email: options.fetch(:email),
                                    billing_address: options.fetch(:address)})
      transaction_id = response.success? ? response.params['requestID'] : nil
      [transaction_id, response]
    end

    def void(options)
      response = gateway.void(options.fetch(:transaction_id))
      transaction_id = response.success? ? response.params['requestID'] : nil
      [transaction_id, response]
    end

  end

end
