# frozen_string_literal: true

module CardanoWallet
  ##
  # General Utils not connected to API
  module Utils
    def self.new(opt)
      Init.new opt
    end

    class Init < Base
      # Generate mnemonic sentence
      #
      # @example Default 24-word English mnemonic sentence
      # CardanoWallet.new.utils.mnemonic_sentence
      # ["kiwi", "rent", "denial",...]
      #
      # @example 15-word French mnemonic sentence
      # CardanoWallet.new.utils.mnemonic_sentence(15, 'french')
      # ["ruser", "malaxer", "forgeron",...]
      def mnemonic_sentence(word_count = 24, language = 'english')
        languages = %w[english french spanish korean japanese
                       italian chinese_traditional chinese_simplified]
        unless languages.include?(language)
          raise ArgumentError,
                %(Not supported language: '#{language}'. Supported languages are: #{languages}.)
        end

        words = [9, 12, 15, 18, 21, 24]
        case word_count
        when 9
          bits = 96
        when 12
          bits = 128
        when 15
          bits = 164
        when 18
          bits = 196
        when 21
          bits = 224
        when 24
          bits = 256
        else
          raise ArgumentError,
                %(Not supported count of words #{word_count}. Supported counts are: #{words}.)
        end
        BipMnemonic.to_mnemonic(bits: bits, language: language).split
      end
    end

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
