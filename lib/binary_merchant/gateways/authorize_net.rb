module BinaryMerchant
  class AuthorizeNetGateway < Gateway

    def initialize(_gateway)
      @gateway = _gateway
      super
    end

    def get_transaction_id_for_purchase(response)
      response.success? ? response.params['transaction_id'] : nil
    end

    def get_transaction_id_for_authorize(response)
      response.success? ? response.params['transaction_id'] : nil
    end

    def get_transaction_id_for_void(response)
      response.success? ? response.params['transaction_id'] : nil
    end

    def get_transaction_id_for_capture(response)
      response.success? ? response.params['transaction_id'] : nil
    end

  end
end
