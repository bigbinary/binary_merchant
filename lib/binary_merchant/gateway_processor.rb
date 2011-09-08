module BinaryMerchant

  class GatewayProcessorException < StandardError
  end

  # Usage
  #
  # gateway = ActiveMerchant::Billing::AuthorizeNetCimGateway.new( :login => login, :password => password )
  # ::GATEWAYP = GatewayProcessor.new( gateway )
  # ::GATEWAYP.add_user('neeraj@BigBinary.com')
  #
  class GatewayProcessor

    attr_reader :gateway

    def initialize(gateway)
      @gateway = gateway
    end

    # Creates customer profile.
    #
    # === Options
    # * <tt>:email</tt> -- User's  email address . This is a required field.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by Active Merchant.
    #
    # If the operation is successful then the first element contains the user vault id
    # returned by Authorize.net . Upon failure the value of first element is set to nil.
    #
    def add_user(options)
      response = gateway.create_customer_profile({:profile => {:email => options.fetch(:email)}})
      value = response.success? ? response.authorization : nil
      [value, response]
    end

    def add_user!(options)
      result = add_user(options).first
      raise GatewayProcessorException unless result.first
      result
    end

    # Creates customer payment profile.
    # Add credit card to the user's paymen profile and returns a vault id for the
    # credit card. This vault id can be used in future transactions. Because of this
    # vault id there is no need to store credit card numbers by the application.
    #
    # === Options
    # * <tt>:user_vault_id</tt> -- The valut id of the user . This is a required field.
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
    # returend by active_merchant.
    #
    # If the operation was successful then the first element contains the payment profile id
    # created by Authorize.net . Upon failure the value of first element is set to nil.
    #
    def add_credit_card(options)
      hash =    {:customer_profile_id => options.fetch(:user_vault_id),
                 :payment_profile => {:payment => {:credit_card => options.fetch(:credit_card)},
                                      :bill_to => options[:address] }}
      response = gateway.create_customer_payment_profile(hash)
      value = response.success? ? response.params['customer_payment_profile_id'] : nil
      [value, response]
    end

    def add_credit_card!(options)
      result = add_credit_card(options)
      raise GatewayProcessorException unless result.first
      result
    end

    # Creates authorization for the given amount.
    #
    # === Options
    #
    # * <tt>:amount</tt> -- Amound to be authorized. This is a required field.
    # * <tt>:credit_card_vault_id</tt> -- Credit card vault id . This is a required field.
    # * <tt>:user_vault_id</tt> -- User vault id . This is a required field.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by active_merchant. The first element has transction_id upon success. Upon failure
    # first element will be set to nil.
    #
    def authorize(options)
      hash =    { transaction: { type: :auth_only,
                                 amount: options.fetch(:amount),
                                 customer_profile_id: options.fetch(:user_vault_id),
                                 customer_payment_profile_id: options.fetch(:credit_card_vault_id) }}
      response = gateway.create_customer_profile_transaction(hash)
      value = response.success? ?  response.params['direct_response']['transaction_id'] : nil
      [value, response]
    end

    def authorize!(options)
      result = authorize(options)
      raise GatewayProcessorException unless result.first
      result
    end

    # Voids a previously created transaction.
    #
    # === Options
    #
    # * <tt>:transaction_id</tt> -- Transaction id to be voided. This is a required field.
    # * <tt>:amount</tt> -- Amound to be voided. This is a required field.
    # * <tt>:user_vault_id</tt> -- User vault id. This is a required field.
    # * <tt>:credit_card_vault_id</tt> -- Credit card vault id. This is a required field.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by active_merchant. The first element has value true upon success. Upon failure
    # first element will be set to false.
    #
    def void(options)
      hash =    { transaction: { type: :void,
                                 trans_id: options.fetch(:transaction_id),
                                 amount: options.fetch(:amount),
                                 customer_profile_id:  options.fetch(:user_vault_id),
                                 customer_payment_profile_id:  options.fetch(:credit_card_vault_id) }}
      response = gateway.create_customer_profile_transaction(hash)
      [response.success?, response]
    end

    def void!(options)
      result = void(options)
      raise GatewayProcessorException unless result.first
      result
    end

    # Refunds a previously captured action.
    #
    # === Options
    #
    # * <tt>:transaction_id</tt> -- Transaction id to be refunded. This is a required field.
    # * <tt>:amount</tt> -- Amound to be refunded. This is a required field.
    # * <tt>:user_vault_id</tt> -- User vault id. This is a required field.
    # * <tt>:credit_card_vault_id</tt> -- Credit card vault id. This is a required field.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by active_merchant. The first element has value true upon success. Upon failure
    # first element will be set to false.
    #
    def refund(options)
      hash =    {:transaction => {:type => :refund,
                                  :amount => options.fetch(:amount),
                                  :customer_profile_id => options.fetch(:user_vault_id),
                                  :customer_payment_profile_id => options.fetch(:credit_card_vault_id),
                                  :trans_id => options.fetch(:transaction_id)}}
      response = gateway.create_customer_profile_transaction(hash)
      [response.success?, response]
    end

    def refund!(options)
      result = refund(options)
      raise GatewayProcessorException unless result.first
      result
    end

    # Captures a previously authorized transaction.
    #
    # === Options
    #
    # * <tt>:transaction_id</tt> -- Transaction id to be captured. This is a required field.
    # * <tt>:amount</tt> -- Amound to be captured. This is a required field.
    # * <tt>:user_vault_id</tt> -- User vault id. This is a required field.
    # * <tt>:credit_card_vault_id</tt> -- Credit card vault id. This is a required field.
    #
    # This method returns an array with two elements. The second element is the response object
    # returend by active_merchant. The first element has value true upon success. Upon failure
    # first element will be set to false.
    #
    def capture(options)
      hash =    { transaction: { type: :prior_auth_capture,
                                 amount: options.fetch(:amount),
                                 customer_profile_id: options.fetch(:user_vault_id),
                                 customer_payment_profile_id: options.fetch(:credit_card_vault_id),
                                 trans_id: options.fetch(:transaction_id)}}
      response = gateway.create_customer_profile_transaction(hash)
      [response.success?, response]
    end

    def capture!(options)
      result = capture(options)
      raise GatewayProcessorException unless result.first
      result
    end

  end

end
