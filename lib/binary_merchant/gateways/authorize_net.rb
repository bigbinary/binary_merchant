module BinaryMerchant #:nodoc:
  class AuthorizeNetGateway < Gateway

    def initialize(_gateway)
      @gateway = _gateway
      super
    end

    # Creates authorization for the given amount.
    #
    # ==== Parameters
    #
    # * <tt>money</tt> -- The amount to be authorized as an Integer value in cents. Required field.
    # * <tt>creditcard</tt> -- The CreditCard details for the transaction. Required field.
    # * <tt>options</tt> -- A hash of optional parameters. You can pass :address , :billing_address and :shipping_address.
    # :address is just a convenience key for :billing_address.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by Active Merchant.
    #
    # If the operation is successful then the first element contains the transaction id
    # returned by Authorize.net . Upon failure the value of first element is set to nil.
    #
    def authorize(money, creditcard, options = {})
      require 'ruby-debug'; debugger
      response = gateway.authorize(money, creditcard, options)
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
