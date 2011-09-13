module BinaryMerchant #:nodoc:
  class AuthorizeNetGateway < Gateway

    def initialize(_gateway)
      @gateway = _gateway
      super
    end

    # Creates authorization for the given amount.
    #
    # === Options
    #
    # * <tt>:amount</tt> -- Amount to be authorized. This is a required field.
    # * <tt>:creditcard</tt> -- credit card object . This is a required field.
    # * <tt>:extra</tt> -- extra hash options. More on this coming up. This is an optional field.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by Active Merchant.
    #
    # If the operation is successful then the first element contains the transaction id
    # returned by Authorize.net . Upon failure the value of first element is set to nil.
    #
    def authorize(options)
      response = gateway.authorize(options.fetch(:amount), options.fetch(:creditcard), options[:extra])
      transaction_id = response.success? ? response.params['transaction_id'] : nil
      [transaction_id, response]
    end

    # Voids a previously created transaction.
    #
    # === Options
    #
    # * <tt>:transaction_id</tt> -- Transaction id to be voided.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by Active Merchant.
    #
    # If the operation is successful then the first element contains the transaction id
    # returned by Authorize.net . Upon failure the value of first element is set to nil.
    #
    def void(options)
      response = gateway.void(options.fetch(:transaction_id))
      transaction_id = response.success? ? response.params['transaction_id'] : nil
      [transaction_id, response]
    end

  end

end
