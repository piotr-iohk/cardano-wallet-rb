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

      # Call API for Shared Keys
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Shared-Keys
      def keys
        Keys.new @opt
      end
    end

    # API for Keys
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Shared-Keys
    class Keys < Base
      # @see https://input-output-hk.github.io/cardano-wallet/api/#operation/getSharedWalletKey
      # https://localhost:8090/v2/shared-wallets/{walletId}/keys/{role}/{index}?hash=false
      def get_public_key(wid, role, index, h = {})
        hash_query = h.empty? ? '' : Utils.to_query(h)
        self.class.get("/shared-wallets/#{wid}/keys/#{role}/#{index}#{hash_query}")
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/#operation/postAccountKeyShared
      def create_acc_public_key(wid, index, pass, extended)
        payload = { passphrase: pass, extended: extended }
        self.class.post("/shared-wallets/#{wid}/keys/#{index}",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
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
        self.class.delete("/shared-wallets/#{wid}")
      end

      # Update payment script
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/patchSharedWalletInPayment
      def update_payment_script(wid, cosigner, acc_pub_key)
        self.class.patch("/shared-wallets/#{wid}/payment-script-template",
                         body: { cosigner => acc_pub_key }.to_json,
                         headers: { 'Content-Type' => 'application/json' })
      end

      # Update delegation script
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/patchSharedWalletInDelegation
      def update_delegation_script(wid, cosigner, acc_pub_key)
        self.class.patch("/shared-wallets/#{wid}/delegation-script-template",
                         body: { cosigner => acc_pub_key }.to_json,
                         headers: { 'Content-Type' => 'application/json' })
      end
    end
  end
end
