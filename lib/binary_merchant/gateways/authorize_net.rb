module BinaryMerchant
  class AuthorizeNetGateway < Gateway

    def initialize(_gateway)
      @gateway = _gateway
      super
    end

    def get_transaction_id_from_authorize(response)
      response.success? ? response.params['transaction_id'] : nil
    end

    def get_transaction_id_from_void(response)
      response.success? ? response.params['transaction_id'] : nil
    end

  end
end
