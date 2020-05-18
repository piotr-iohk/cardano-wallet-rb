module CardanoWallet
  module Utils

    def self.verify_param_is_hash!(param)
      raise ArgumentError, "argument should be Hash" unless param.is_a?(Hash)
    end

    def self.format_payments(payments)
      verify_param_is_hash!(payments)
      payments.collect do |addr, amt|
        {:address => addr.to_s,
         :amount => {:quantity => amt.to_i,
                     :unit => "lovelace"}
        }
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
