module BinaryMerchant #:nodoc:
  class AuthorizeNetCimGateway < Gateway

    def initialize(_gateway)
      @gateway = _gateway
    end

    # Creates customer profile.
    #
    # === Options
    # * <tt>:email</tt> -- User's  email address . This is a required field.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by Active Merchant.
    #
    # If the operation is successful then the first element contains the customer profile id
    # returned by Authorize.net . Upon failure the value of first element is set to nil.
    #
    def add_user(options)
      response = gateway.create_customer_profile({:profile => {:email => options.fetch(:email)}})
      customer_profile_id = response.success? ? response.authorization : nil
      [customer_profile_id, response]
    end

    # Adds credit card to the payment profile. Authorize.net calls it creating
    # customer payment profile.
    #
    # Adds credit card to the user's payment profile and returns payment profile id for the
    # credit card. This payment profile id can be used in future transactions. Because of this
    # payment profile id there is no need to store credit card numbers by the application.
    #
    # === Options
    # * <tt>:customer_profile_id</tt> -- The customer profile id of the user . This is a required field.
    # * <tt>:credit_card</tt> -- The credit_card object containing credit card information . The
    #   credit_card object should respond to following methods: number, month, year and
    #   verification_value.  <tt> credit_card.verification_value?</tt> should return true if you
    #   want verification_value to be matched. What Active Merchant is calling verifcaton value
    #   is also commonly known as CVV value. This is a required field.
    # * <tt>:address</tt> -- Bill to address to be associated to credit card. This is a hash
    #   with following keys: :first_name, :last_name, :company, :address1, :address2, :city
    #   :state, :country, :phone_number, :fax_number . This is an optional field. Fields are also
    #   optional so you can pass only the fields that you are interested in storing.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by Active Merchant.
    #
    # If the operation was successful then the first element contains the payment profile id
    # created by Authorize.net . Upon failure the value of first element is set to nil.
    #
    def add_credit_card(options)
      hash =    {:customer_profile_id => options.fetch(:customer_profile_id),
                 :payment_profile => {:payment => {:credit_card => options.fetch(:credit_card)},
                                      :bill_to => options[:address] }}
      response = gateway.create_customer_payment_profile(hash)
      payment_profile_id = response.success? ? response.params['customer_payment_profile_id'] : nil
      [payment_profile_id, response]
    end

    def delete_credit_card(options)
      hash = {customer_profile_id: options.fetch(:customer_profile_id),
              customer_payment_profile_id: options.fetch(:customer_payment_profile_id)}
      response = gateway.delete_customer_payment_profile(hash)
      [response.success?, response]
    end

    # Creates authorization for the given amount.
    #
    # === Options
    #
    # * <tt>:amount</tt> -- Amount to be authorized. This is a required field.
    # * <tt>:customer_payment_profile_id</tt> -- This is a required field.
    # * <tt>:customer_profile_id</tt> -- This is a required field.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by active_merchant. The first element has transction_id upon success. Upon failure
    # first element will be set to nil.
    #
    def authorize(options)
      hash =    { transaction: { type: :auth_only,
                                 amount: options.fetch(:amount),
                                 customer_profile_id: options.fetch(:customer_profile_id),
                                 customer_payment_profile_id: options.fetch(:customer_payment_profile_id) }}
      response = gateway.create_customer_profile_transaction(hash)
      transaction_id = response.success? ?  response.params['direct_response']['transaction_id'] : nil
      [transaction_id, response]
    end

    # Voids a previously created transaction.
    #
    # === Options
    #
    # * <tt>:transaction_id</tt> -- Transaction id to be voided. This is a required field.
    # * <tt>:amount</tt> -- Amound to be voided. This is a required field.
    # * <tt>:customer_profile_id</tt> -- This is a required field.
    # * <tt>:customer_payment_profile_id</tt> -- This is a required field.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by active_merchant. The first element has value true upon success. Upon failure
    # first element will be set to false.
    #
    def void(options)
      hash =    { transaction: { type: :void,
                                 trans_id: options.fetch(:transaction_id),
                                 amount: options.fetch(:amount),
                                 customer_profile_id:  options.fetch(:customer_profile_id),
                                 customer_payment_profile_id:  options.fetch(:customer_payment_profile_id) }}
      response = gateway.create_customer_profile_transaction(hash)
      transaction_id = response.success? ?  response.params['direct_response']['transaction_id'] : nil
      [transaction_id, response]
    end

    # Refunds a previously captured action.
    #
    # === Options
    #
    # * <tt>:transaction_id</tt> -- Transaction id to be refunded. This is a required field.
    # * <tt>:amount</tt> -- Amount to be refunded. This is a required field.
    # * <tt>:customer_profile_id</tt> -- This is a required field.
    # * <tt>:customer_payment_profile_id</tt> -- This is a required field.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by active_merchant. The first element has value true upon success. Upon failure
    # first element will be set to false.
    #
    def refund(options)
      hash =    {:transaction => {:type => :refund,
                                  :amount => options.fetch(:amount),
                                  :customer_profile_id => options.fetch(:customer_profile_id),
                                  :customer_payment_profile_id => options.fetch(:customer_payment_profile_id),
                                  :trans_id => options.fetch(:transaction_id)}}
      response = gateway.create_customer_profile_transaction(hash)
      transaction_id = response.success? ?  response.params['direct_response']['transaction_id'] : nil
      [transaction_id, response]
    end

    # Captures a previously authorized transaction.
    #
    # === Options
    #
    # * <tt>:transaction_id</tt> -- Transaction id to be captured. This is a required field.
    # * <tt>:amount</tt> -- Amount to be captured. This is a required field.
    # * <tt>:customer_profile_id</tt> -- This is a required field.
    # * <tt>:customer_payment_profile_id</tt> -- This is a required field.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by active_merchant. The first element has value true upon success. Upon failure
    # first element will be set to false.
    #
    def capture(options)
      hash =    { transaction: { type: :prior_auth_capture,
                                 amount: options.fetch(:amount),
                                 customer_profile_id: options.fetch(:customer_profile_id),
                                 customer_payment_profile_id: options.fetch(:customer_payment_profile_id),
                                 trans_id: options.fetch(:transaction_id)}}
      response = gateway.create_customer_profile_transaction(hash)
      transaction_id = response.success? ?  response.params['direct_response']['transaction_id'] : nil
      [transaction_id, response]
    end

  end
end
