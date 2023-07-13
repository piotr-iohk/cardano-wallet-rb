# frozen_string_literal: true

module CardanoWallet
  # Init API for Shelley Shared wallets
  # @example
  #  @cw = CardanoWallet.new
  #  @cw.shared # API for Shared
  module Shared
    def self.new(opt)
      Init.new opt
    end

    ##
    # Base class for Shelley Shared Wallets API
    class Init < Base
      # Call API for Wallets
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Shared-Wallets
      def wallets
        Wallets.new @opt
      end

      # Call API for Shared Keys
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Shared-Keys
      def keys
        Keys.new @opt
      end

      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Shared-Addresses
      def addresses
        Addresses.new @opt
      end

      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Shared-Transactions
      def transactions
        Transactions.new @opt
      end
    end

    # API for Transactions
    # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Shared-Transactions
    # @example
    #  @cw = CardanoWallet.new
    #  @cw.shared.transactions # API for Shared transactions
    class Transactions < Base
      # Construct transaction
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/constructSharedTransaction
      # @param wid [String] source wallet id
      # @param payments [Array of Hashes] full payments payload with assets
      # @param withdrawal [String or Array] 'self' or mnemonic sentence
      # @param metadata [Hash] special metadata JSON subset format (cf: https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/postTransaction)
      # @param mint [Array of Hashes] mint object
      # @param delegations [Array of Hashes] delegations object
      # @param validity_interval [Hash] validity_interval object
      # @param encoding [String] output encoding ("base16" or "base64")
      def construct(wid,
                    payments = nil,
                    withdrawal = nil,
                    metadata = nil,
                    delegations = nil,
                    mint = nil,
                    validity_interval = nil,
                    encoding = nil)
        payload = {}
        payload[:payments] = payments if payments
        payload[:withdrawal] = withdrawal if withdrawal
        payload[:metadata] = metadata if metadata
        payload[:mint_burn] = mint if mint
        payload[:delegations] = delegations if delegations
        payload[:validity_interval] = validity_interval if validity_interval
        payload[:encoding] = encoding if encoding

        self.class.post("/shared-wallets/#{wid}/transactions-construct",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Decode transaction
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/decodeSharedTransaction
      # @param wid [String] source wallet id
      # @param transaction [String] CBOR base64|base16 encoded transaction
      def decode(wid, transaction)
        payload = {}
        payload[:transaction] = transaction
        self.class.post("/shared-wallets/#{wid}/transactions-decode",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Sign transaction
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/signSharedTransaction
      # @param wid [String] source wallet id
      # @param passphrase [String] wallet's passphrase
      # @param transaction [String] CBOR transaction data
      # @param encoding [String] output encoding ("base16" or "base64")
      def sign(wid, passphrase, transaction, encoding = nil)
        payload = {
          'passphrase' => passphrase,
          'transaction' => transaction
        }
        payload[:encoding] = encoding if encoding
        self.class.post("/shared-wallets/#{wid}/transactions-sign",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Submit transaction
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/submitSharedTransaction
      # @param wid [String] source wallet id
      # @param transaction [String] CBOR transaction data
      def submit(wid, transaction)
        payload = { 'transaction' => transaction }
        self.class.post("/shared-wallets/#{wid}/transactions-submit",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Get tx by id
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/getSharedTransaction
      def get(wid, tx_id, query = {})
        query_formatted = query.empty? ? '' : Utils.to_query(query)
        self.class.get("/shared-wallets/#{wid}/transactions/#{tx_id}#{query_formatted}")
      end

      # List all wallet's transactions
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/listSharedTransactions
      #
      # @example
      #   list(wid, {start: "2012-09-25T10:15:00Z", order: "descending"})
      def list(wid, query = {})
        query_formatted = query.empty? ? '' : Utils.to_query(query)
        self.class.get("/shared-wallets/#{wid}/transactions#{query_formatted}")
      end
    end

    # API for Addresses
    # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Shared-Addresses
    # @example
    #  @cw = CardanoWallet.new
    #  @cw.shared.addresses # API for Shared addresses
    class Addresses < Base
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/listSharedAddresses
      def list(wid, query = {})
        query_formatted = query.empty? ? '' : Utils.to_query(query)
        self.class.get("/shared-wallets/#{wid}/addresses#{query_formatted}")
      end
    end

    # API for Keys
    # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Shared-Keys
    # @example
    #  @cw = CardanoWallet.new
    #  @cw.shared.keys # API for Shared Keys
    class Keys < Base
      # @see https://cardano-foundation.github.io/cardano-wallet/api/#operation/getSharedWalletKey
      def get_public_key(wid, role, index, hash = {})
        hash_query = hash.empty? ? '' : Utils.to_query(hash)
        self.class.get("/shared-wallets/#{wid}/keys/#{role}/#{index}#{hash_query}")
      end

      # @see https://cardano-foundation.github.io/cardano-wallet/api/#operation/postAccountKeyShared
      def create_acc_public_key(wid, index, payload)
        # payload = { passphrase: pass, format: format }
        Utils.verify_param_is_hash!(payload)
        self.class.post("/shared-wallets/#{wid}/keys/#{index}",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/getAccountKeyShared
      def get_acc_public_key(wid, query = {})
        query_formatted = query.empty? ? '' : Utils.to_query(query)
        self.class.get("/shared-wallets/#{wid}/keys#{query_formatted}")
      end
    end

    # API for Wallets
    # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Shared-Wallets
    # @example
    #  @cw = CardanoWallet.new
    #  @cw.shared.wallets # API for Shared Wallets
    class Wallets < Base
      # List all wallets
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/listSharedWallets
      def list
        self.class.get('/shared-wallets')
      end

      # Get wallet details
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/getSharedWallet
      def get(wid)
        self.class.get("/shared-wallets/#{wid}")
      end

      # Create a wallet based on the params.
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/postSharedWallet
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
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/deleteSharedWallet
      def delete(wid)
        self.class.delete("/shared-wallets/#{wid}")
      end

      # Update payment script
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/patchSharedWalletInPayment
      def update_payment_script(wid, cosigner, acc_pub_key)
        self.class.patch("/shared-wallets/#{wid}/payment-script-template",
                         body: { cosigner => acc_pub_key }.to_json,
                         headers: { 'Content-Type' => 'application/json' })
      end

      # Update delegation script
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/patchSharedWalletInDelegation
      def update_delegation_script(wid, cosigner, acc_pub_key)
        self.class.patch("/shared-wallets/#{wid}/delegation-script-template",
                         body: { cosigner => acc_pub_key }.to_json,
                         headers: { 'Content-Type' => 'application/json' })
      end

      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/getUTxOsStatistics
      def utxo(wid)
        self.class.get("/shared-wallets/#{wid}/statistics/utxos")
      end

      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/getWalletUtxoSnapshot
      def utxo_snapshot(wid)
        self.class.get("/shared-wallets/#{wid}/utxo")
      end
    end
  end
end
