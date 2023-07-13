# frozen_string_literal: true

module CardanoWallet
  ##
  # Byron APIs
  # @example
  #  @cw = CardanoWallet.new
  #  @cw.byron # API for Byron
  module Byron
    def self.new(opt)
      Init.new opt
    end

    ##
    # Init class for Byron APIs.
    # @example
    #  @cw = CardanoWallet.new
    #  @cw.byron.wallets # API for Byron wallets
    #  @cw.byron.assets # API for Byron assets
    #  @cw.byron.coin_selections # API for Byron coin_selections
    #  @cw.byron.addresses # API for Byron addresses
    #  @cw.byron.transactions # API for Byron transactions
    #  @cw.byron.migrations # API for Byron migrations
    class Init < Base
      # Get API for Byron wallets
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Byron-Wallets
      def wallets
        Wallets.new @opt
      end

      # Get API for Byron addresses
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Byron-Addresses
      def addresses
        Addresses.new @opt
      end

      # API for CoinSelections
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Byron-Coin-Selections
      def coin_selections
        CoinSelections.new @opt
      end

      # Get API for Byron transactions
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/postByronTransactionFee
      def transactions
        Transactions.new @opt
      end

      # Get API for Byron migrations
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Byron-Migrations
      def migrations
        Migrations.new @opt
      end

      # API for Assets
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Byron-Assets
      def assets
        Assets.new @opt
      end
    end

    ##
    # Init for Byron assets APIs
    # @example
    #  @cw = CardanoWallet.new
    #  @cw.byron.assets # API for Byron assets
    class Assets < Base
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/listByronAssets
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/getByronAsset
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/getByronAssetDefault
      # @example Get all assets that were ever involved in wallet transaction and been on balance
      #  @cw.byron.assets.get(wallet_id)
      def get(wid, policy_id = nil, asset_name = nil)
        ep = "/byron-wallets/#{wid}/assets"
        ep += "/#{policy_id}" if policy_id
        ep += "/#{asset_name}" if asset_name
        self.class.get(ep)
      end
    end

    # Byron wallets
    # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Byron-Wallets
    # @example
    #  @cw = CardanoWallet.new
    #  @cw.byron.wallets # API for Byron wallets
    class Wallets < Base
      # List Byron wallets
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/listByronWallets
      # @example Get all Byron wallets
      #  @cw.byron.wallets.get
      def list
        self.class.get('/byron-wallets')
      end

      # Get Byron wallet details
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/getByronWallet
      # @example Get Byron wallet details
      #  @cw.byron.wallets.get(wallet_id)
      def get(wid)
        self.class.get("/byron-wallets/#{wid}")
      end

      # Create a Byron wallet based on the params.
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/postByronWallet
      #
      # @example
      #   create({style: "random",
      #           name: "Random Wallet from mnemonic_sentence",
      #           passphrase: "Secure Passphrase",
      #           mnemonic_sentence: %w[arctic decade pizza ...],
      #          })
      def create(params)
        Utils.verify_param_is_hash!(params)
        self.class.post('/byron-wallets',
                        body: params.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Delete Byron wallet
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/deleteByronWallet
      # @example Delete Byron wallet
      #  @cw.byron.wallets.delete(wallet_id)
      def delete(wid)
        self.class.delete("/byron-wallets/#{wid}")
      end

      # Update Byron wallet's metadata
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/putByronWallet
      #
      # @example
      #   @cw.byron.wallets.update_metadata(wid, {name: "New wallet name"})
      def update_metadata(wid, params)
        Utils.verify_param_is_hash!(params)
        self.class.put("/byron-wallets/#{wid}",
                       body: params.to_json,
                       headers: { 'Content-Type' => 'application/json' })
      end

      # See Byron wallet's utxo distribution
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/getByronUTxOsStatistics
      # @example
      #   @cw.byron.wallets.utxo(wallet_id)
      def utxo(wid)
        self.class.get("/byron-wallets/#{wid}/statistics/utxos")
      end

      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/getByronWalletUtxoSnapshot
      # @example
      #   @cw.byron.wallets.utxo_snapshot(wallet_id)
      def utxo_snapshot(wid)
        self.class.get("/byron-wallets/#{wid}/utxo")
      end

      # Update Byron wallet's passphrase.
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/putByronWalletPassphrase
      #
      # @example
      #   @cw.byron.wallets.update_passphrase(wid, {old_passphrase: "Secure Passphrase",
      #                                             new_passphrase: "Securer Passphrase"})
      def update_passphrase(wid, params)
        Utils.verify_param_is_hash!(params)
        self.class.put("/byron-wallets/#{wid}/passphrase",
                       body: params.to_json,
                       headers: { 'Content-Type' => 'application/json' })
      end
    end

    # Byron addresses
    # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Byron-Addresses
    # @example
    #  @cw = CardanoWallet.new
    #  @cw.byron.addresses # API for Byron addresses
    class Addresses < Base
      # List Byron addresses.
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/listByronAddresses
      #
      # @example
      #   @cw.byron.addresses.list(wid, {state: "used"})
      def list(wid, query = {})
        query_formatted = query.empty? ? '' : Utils.to_query(query)
        self.class.get("/byron-wallets/#{wid}/addresses#{query_formatted}")
      end

      # Create address for Byron random wallet.
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/createAddress
      # @param wid [String] wallet id
      # @param params [Hash] passphrase and (optional) address_index
      #
      # @example Create address with index.
      #   @cw.byron.addresses.create(wid, {passphrase: "Secure Passphrase", address_index: 2147483648})
      # @example Create address with random index.
      #   @cw.byron.addresses.create(wid, {passphrase: "Secure Passphrase"})
      def create(wid, params)
        Utils.verify_param_is_hash!(params)
        self.class.post("/byron-wallets/#{wid}/addresses",
                        body: params.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Import address to Byron wallet.
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/importAddress
      # @param wid [String] wallet id
      # @param addr_id [String] address id
      def import(wid, addr_id)
        self.class.put("/byron-wallets/#{wid}/addresses/#{addr_id}")
      end

      # Import addresses to Byron wallet.
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/importAddresses
      # @param wid [String] wallet id
      # @param addresses [Array] array of addresses
      def bulk_import(wid, addresses)
        self.class.put("/byron-wallets/#{wid}/addresses",
                       body: { addresses: addresses }.to_json,
                       headers: { 'Content-Type' => 'application/json' })
      end
    end

    # API for CoinSelections
    # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Byron-Coin-Selections
    # @example
    #  @cw = CardanoWallet.new
    #  @cw.byron.coin_selections # API for Byron coin_selections
    class CoinSelections < Base
      # Show random coin selection for particular payment
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/byronSelectCoins
      #
      # @example
      #   @cw.byron.coin_selections.random(wid, [{addr1: 1000000}, {addr2: 1000000}])
      #   @cw.byron.coin_selections.random(wid, [{ "address": "addr1..",
      #                  "amount": { "quantity": 42000000, "unit": "lovelace" },
      #                  "assets": [{"policy_id": "pid", "asset_name": "name", "quantity": 0 } ] } ])
      def random(wid, payments)
        Utils.verify_param_is_array!(payments)
        payments_formatted = if payments.any? { |p| p.key?(:address) || p.key?('address') }
                               payments
                             else
                               Utils.format_payments(payments)
                             end
        self.class.post("/byron-wallets/#{wid}/coin-selections/random",
                        body: { payments: payments_formatted }.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end
    end

    # Byron transactions
    # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/postByronTransactionFee
    # @example
    #  @cw = CardanoWallet.new
    #  @cw.byron.transactions # API for Byron Transactions
    class Transactions < Base
      # Construct transaction
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/constructByronTransaction
      # @param wid [String] source wallet id
      # @param payments [Array of Hashes] full payments payload with assets
      # @param metadata [Hash] special metadata JSON subset format (cf: https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/postTransaction)
      # @param mint [Array of Hashes] mint object
      # @param validity_interval [Hash] validity_interval object
      def construct(wid, payments = nil, metadata = nil, mint = nil, validity_interval = nil)
        payload = {}
        payload[:payments] = payments if payments
        payload[:metadata] = metadata if metadata
        payload[:mint] = mint if mint
        payload[:validity_interval] = validity_interval if validity_interval

        self.class.post("/byron-wallets/#{wid}/transactions-construct",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Sign transaction
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/signByronTransaction
      # @param wid [String] source wallet id
      # @param passphrase [String] wallet's passphrase
      # @param transaction [String] CBOR transaction data
      def sign(wid, passphrase, transaction)
        payload = {
          'passphrase' => passphrase,
          'transaction' => transaction
        }

        self.class.post("/byron-wallets/#{wid}/transactions-sign",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Submit transaction
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/submitByronTransaction
      # @param wid [String] source wallet id
      # @param transaction [String] CBOR transaction data
      def submit(wid, transaction)
        payload = { 'transaction' => transaction }
        self.class.post("/byron-wallets/#{wid}/transactions-submit",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Get tx by id
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/getByronTransaction
      def get(wid, tx_id)
        self.class.get("/byron-wallets/#{wid}/transactions/#{tx_id}")
      end

      # List all Byron wallet's transactions.
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/listByronTransactions
      #
      # @example
      #   @cw.byron.transactions.list(wid, {start: "2012-09-25T10:15:00Z", order: "descending"})
      def list(wid, query = {})
        query_formatted = query.empty? ? '' : Utils.to_query(query)
        self.class.get("/byron-wallets/#{wid}/transactions#{query_formatted}")
      end

      # Create a transaction from the Byron wallet.
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/postByronTransaction
      # @param wid [String] source wallet id
      # @param passphrase [String] source wallet's passphrase
      # @param payments [Array of Hashes] addres, amount pair
      #
      # @example
      #   @cw.byron.transactions.create(wid, passphrase, [{addr1: 1000000}, {addr2: 1000000}])
      #   @cw.byron.transactions.create(wid, passphrase, [{ "address": "addr1..",
      #                              "amount": { "quantity": 42000000, "unit": "lovelace" },
      #                              "assets": [{"policy_id": "pid", "asset_name": "name", "quantity": 0 } ] } ])

      def create(wid, passphrase, payments)
        Utils.verify_param_is_array!(payments)
        payments_formatted = if payments.any? { |p| p.key?(:address) || p.key?('address') }
                               payments
                             else
                               Utils.format_payments(payments)
                             end
        self.class.post("/byron-wallets/#{wid}/transactions",
                        body: { payments: payments_formatted,
                                passphrase: passphrase }.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Estimate fees for transaction
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/postTransactionFee
      #
      # @example
      #   @cw.byron.transactions.payment_fees(wid, [{addr1: 1000000}, {addr2: 1000000}])
      #   @cw.byron.transactions.payment_fees(wid, [{ "address": "addr1..",
      #                        "amount": { "quantity": 42000000, "unit": "lovelace" },
      #                        "assets": [{"policy_id": "pid", "asset_name": "name", "quantity": 0 } ] } ])
      def payment_fees(wid, payments)
        Utils.verify_param_is_array!(payments)
        payments_formatted = if payments.any? { |p| p.key?(:address) || p.key?('address') }
                               payments
                             else
                               Utils.format_payments(payments)
                             end
        self.class.post("/byron-wallets/#{wid}/payment-fees",
                        body: { payments: payments_formatted }.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Forget a transaction.
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/deleteByronTransaction
      def forget(wid, txid)
        self.class.delete("/byron-wallets/#{wid}/transactions/#{txid}")
      end
    end

    # Byron migrations
    # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#tag/Byron-Migrations
    # @example
    #  @cw = CardanoWallet.new
    #  @cw.byron.migrations # API for Byron Migrations
    class Migrations < Base
      # Get migration plan
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/createByronWalletMigrationPlan
      def plan(wid, addresses)
        self.class.post("/byron-wallets/#{wid}/migrations/plan",
                        body: { addresses: addresses }.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Migrate all funds from Byron wallet.
      # @see https://cardano-foundation.github.io/cardano-wallet/api/edge/#operation/migrateByronWallet
      # @param wid [String] wallet id
      # @param passphrase [String] wallet's passphrase
      # @param [Array] array of addresses
      def migrate(wid, passphrase, addresses)
        self.class.post("/byron-wallets/#{wid}/migrations",
                        body: { addresses: addresses,
                                passphrase: passphrase }.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end
    end
  end
end
