# frozen_string_literal: true

module CardanoWallet
  ##
  # General Utils not connected to API
  module Utils
    def self.verify_param_is_hash!(param)
      raise ArgumentError, 'argument should be Hash' unless param.is_a?(Hash)
    end

    def self.verify_param_is_array!(param)
      raise ArgumentError, 'argument should be Array' unless param.is_a?(Array)
    end

    ##
    # @param payments [Array of Hashes] - [{addr1: 1}, {addr2: 2}]
    # @return [Array of Hashes] - [{:address=>"addr1", :amount=>{:quantity=>1, :unit=>"lovelace"}}, {...}}]
    def self.format_payments(payments)
      verify_param_is_array!(payments)
      unless payments.all? { |p| p.size == 1 && p.is_a?(Hash) }
        raise ArgumentError, 'argument should be Array of single Hashes'
      end

      payments.map do |p|
        a = p.collect do |addr, amt|
          { address: addr.to_s,
            amount: { quantity: amt.to_i,
                      unit: 'lovelace' } }
        end.flatten
        Hash[*a]
      end
    end

    def self.to_query(query)
      verify_param_is_hash!(query)
      q = query.collect do |k, v|
        "#{k}=#{v}"
      end.join '&'
      "?#{q}"
    end
  end
end
