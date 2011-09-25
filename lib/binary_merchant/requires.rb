module ActiveMerchant #:nodoc:
  module RequiresParameters #:nodoc:
    def requires!(hash, *params)
      params.each do |param|
        if param.is_a?(Array)
          raise ArgumentError.new("Missing required parameter: #{param.first}") unless hash.has_key?(param.first)

          # line added by binary_merchant
          raise ArgumentError.new("Missing value for parameter: #{param.first}") if hash[param.first].nil?

          valid_options = param[1..-1]
          raise ArgumentError.new("Parameter: #{param.first} must be one of #{valid_options.to_sentence(:words_connector => 'or')}") unless valid_options.include?(hash[param.first])
        else
          raise ArgumentError.new("Missing required parameter: #{param}") if hash.has_key?(param).nil?

          # line added by binary_merchant
          raise ArgumentError.new("Missing value for parameter: #{param}") unless hash[param]
        end
      end
    end
  end
end

