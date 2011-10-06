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
      identification = []
      identification << options.fetch(:order_id)
      identification << options.fetch(:transaction_gid)
      identification << options.fetch(:request_token)

      response = gateway.capture(options.fetch(:amount),
                                   identification.join(';'),
                                   { billing_address: options.fetch(:address)})
      transaction_id = response.success? ? response.params['requestID'] : nil
      [transaction_id, response]
    end

    def auth_reversal(options)
      identification = []
      identification << options.fetch(:order_id)
      identification << options.fetch(:transaction_gid)
      identification << options.fetch(:request_token)

      response = gateway.auth_reversal(options.fetch(:amount),identification.join(';'))
      transaction_id = response.success? ? response.params['requestID'] : nil
      [transaction_id, response]
    end

    def void(options)
      identification = []
      identification << options.fetch(:order_id)
      identification << options.fetch(:transaction_gid)
      identification << options.fetch(:request_token)

      response = gateway.void(identification.join(';'))
      transaction_id = response.success? ? response.params['requestID'] : nil
      [transaction_id, response]
    end

  end

end
