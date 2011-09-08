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
    # returend by active_merchant.
    #
    # If the operation was successful then the first element contains the user vault id
    # created by Authorize.net . Upon failure the value of first element is set to nil.
    #
    def add_user(options)
      response = gateway.create_customer_profile({:profile => {:email => options.fetch(:email)}})
      value = response.success? ? response.authorization : nil
      [value, response]
    end

    def add_user!(options)
      raise GatewayProcessorException unless add_user(options).first
    end

    # Creates customer payment profile.
    #
    # === Options
    # * <tt>:user_vault_id</tt> -- The valut id of the user . This is a required field.
    # * <tt>:credit_card</tt> -- The credit_card object containing credit card information . The
    #   credit_card object should respond to following methods: number, month, year and
    #   verification_value.  <tt> credit_card.verification_value?</tt> should return true if
    #   want verification_value to be matched. This is a required field.
    # * <tt>:address</tt> -- Bill to address to be associated to credit card. This is a hash
    #   with following keys: :first_name, :last_name, :company, :address1, :address2, :city
    #   :state, :country, :phone_number, :fax_number . This is an optional field.
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
      raise GatewayProcessorException unless add_credit_card(options).first
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
    # returend by active_merchant. The first element has value true upon success. Upon failure
    # first element will be set to false.
    #
    def authorize(options)
      hash =    { transaction: { type: :auth_only,
                                 amount: options.fetch(:amount),
                                 customer_profile_id: options.fetch(:user_vault_id),
                                 customer_payment_profile_id: options.fetch(:credit_card_vault_id) }}
      response = gateway.create_customer_profile_transaction(hash)
      [response.success?, response]
    end

    def authorize!(options)
      raise GatewayProcessorException unless authorize(options).first
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
      raise GatewayProcessorException unless void(options).first
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
      raise GatewayProcessorException unless refund(options).first
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
      raise GatewayProcessorException unless capture(options).first
    end

  end

end
