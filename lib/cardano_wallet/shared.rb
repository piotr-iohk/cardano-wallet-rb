# frozen_string_literal: true

module CardanoWallet
  # Init API for Shelley Shared wallets
  module Shared
    def self.new(opt)
      Init.new opt
    end

    ##
    # Base class for Shelley Shared Wallets API
    class Init < Base
      # Call API for Wallets
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Shared-Wallets
      def wallets
        Wallets.new @opt
      end
    end

    # API for Wallets
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Shared-Wallets
    class Wallets < Base
      # List all wallets
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/listWallets
      # def list
      #   self.class.get('/shared-wallets')
      # end

      # Get wallet details
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getSharedWallet
      def get(wid)
        self.class.get("/shared-wallets/#{wid}")
      end

      # Create a wallet based on the params.
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/postSharedWallet
      #
      # @example Create wallet from mnemonic sentence
      #   create({name: "Wallet from mnemonic_sentence",
      #           passphrase: "Secure Passphrase",
      #           mnemonic_sentence: %w[story egg fun ... ],
      #           account_index: "1852H",
      #           payment_script_template: {...},
      #           ...
      #          })
      def create(params)
        Utils.verify_param_is_hash!(params)
        self.class.post('/shared-wallets',
                        body: params.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Delete wallet
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/deleteSharedWallet
      def delete(wid)
        self.class.delete("/wallets/#{wid}")
      end
    end
  end
end
