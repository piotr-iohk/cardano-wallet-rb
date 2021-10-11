# frozen_string_literal: true

module CardanoWallet
  # Init API for Shelley
  module Shelley
    def self.new(opt)
      Init.new opt
    end

    ##
    # Base class for Shelley API
    class Init < Base
      # Call API for Wallets
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Wallets
      def wallets
        Wallets.new @opt
      end

      # API for Addresses
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Addresses
      def addresses
        Addresses.new @opt
      end

      # API for CoinSelections
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Coin-Selections
      def coin_selections
        CoinSelections.new @opt
      end

      # API for Transactions
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Transactions
      def transactions
        Transactions.new @opt
      end

      # API for StakePools
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Stake-Pools
      def stake_pools
        StakePools.new @opt
      end

      # API for Migrations
      # @see https://input-output-hk.github.io/cardano-wallet/api/#tag/Migrations
      def migrations
        Migrations.new @opt
      end

      # API for Keys
      # @see https://input-output-hk.github.io/cardano-wallet/api/#tag/Keys
      def keys
        Keys.new @opt
      end

      # API for Assets
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Assets
      def assets
        Assets.new @opt
      end
    end

    ##
    # Base class for Shelley Assets API
    class Assets < Base
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/mintBurnAssets
      def mint(wid, mint_burn, pass, metadata = nil, ttl = nil)
        payload = {
          mint_burn: mint_burn,
          passphrase: pass
        }

        payload[:metadata] = metadata if metadata
        payload[:time_to_live] = { quantity: ttl, unit: 'second' } if ttl

        self.class.post("/wallets/#{wid}/assets",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/listAssets
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getAsset
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getAssetDefault
      def get(wid, policy_id = nil, asset_name = nil)
        ep = "/wallets/#{wid}/assets"
        ep += "/#{policy_id}" if policy_id
        ep += "/#{asset_name}" if asset_name
        self.class.get(ep)
      end
    end

    ##
    # Base class for Shelley Keys API
    class Keys < Base
      # @see https://input-output-hk.github.io/cardano-wallet/api/#operation/signMetadata
      def sign_metadata(wid, role, index, pass, metadata)
        payload = { passphrase: pass }
        payload[:metadata] = metadata if metadata

        self.class.post("/wallets/#{wid}/signatures/#{role}/#{index}",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json',
                                   'Accept' => 'application/octet-stream' })
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/#operation/getWalletKey
      def get_public_key(wid, role, index, query = {})
        query_formatted = query.empty? ? '' : Utils.to_query(query)
        self.class.get("/wallets/#{wid}/keys/#{role}/#{index}#{query_formatted}")
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/#operation/postAccountKey
      def create_acc_public_key(wid, index, payload)
        # payload = { passphrase: pass, format: format, purpose: purpose }
        Utils.verify_param_is_hash!(payload)
        self.class.post("/wallets/#{wid}/keys/#{index}",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getAccountKey
      def get_acc_public_key(wid, query = {})
        query_formatted = query.empty? ? '' : Utils.to_query(query)
        self.class.get("/wallets/#{wid}/keys#{query_formatted}")
      end
    end

    # API for Wallets
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Wallets
    class Wallets < Base
      # List all wallets
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/listWallets
      def list
        self.class.get('/wallets')
      end

      # Get wallet details
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getWallet
      def get(wid)
        self.class.get("/wallets/#{wid}")
      end

      # Create a wallet based on the params.
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/postWallet
      #
      # @example Create wallet from mnemonic sentence
      #   create({name: "Wallet from mnemonic_sentence",
      #           passphrase: "Secure Passphrase",
      #           mnemonic_sentence: %w[story egg fun ... ],
      #          })
      # @example Create wallet from pub key
      #   create({name: "Wallet from pub key",
      #           account_public_key: "b47546e...",
      #           address_pool_gap: 20,
      #          })
      def create(params)
        Utils.verify_param_is_hash!(params)
        self.class.post('/wallets',
                        body: params.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Delete wallet
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/deleteWallet
      def delete(wid)
        self.class.delete("/wallets/#{wid}")
      end

      # Update wallet's metadata
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/putWallet
      #
      # @example
      #   update_metadata(wid, {name: "New wallet name"})
      def update_metadata(wid, params)
        Utils.verify_param_is_hash!(params)
        self.class.put("/wallets/#{wid}",
                       body: params.to_json,
                       headers: { 'Content-Type' => 'application/json' })
      end

      # See wallet's utxo distribution
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getUTxOsStatistics
      def utxo(wid)
        self.class.get("/wallets/#{wid}/statistics/utxos")
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getWalletUtxoSnapshot
      def utxo_snapshot(wid)
        self.class.get("/wallets/#{wid}/utxo")
      end

      # Update wallet's passphrase
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/putWalletPassphrase
      #
      # @example
      #   update_passphrase(wid, {old_passphrase: "Secure Passphrase", new_passphrase: "Securer Passphrase"})
      def update_passphrase(wid, params)
        Utils.verify_param_is_hash!(params)
        self.class.put("/wallets/#{wid}/passphrase",
                       body: params.to_json,
                       headers: { 'Content-Type' => 'application/json' })
      end
    end

    # API for Addresses
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Addresses
    class Addresses < Base
      # List addresses
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/listAddresses
      #
      # @example
      #   list(wid, {state: "used"})
      def list(wid, query = {})
        query_formatted = query.empty? ? '' : Utils.to_query(query)
        self.class.get("/wallets/#{wid}/addresses#{query_formatted}")
      end
    end

    # API for CoinSelections
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Coin-Selections
    class CoinSelections < Base
      # Show random coin selection for particular payment
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/selectCoins
      #
      # @example
      #   random(wid, [{addr1: 1000000}, {addr2: 1000000}])
      #   random(wid, [{ "address": "addr1..",
      #                  "amount": { "quantity": 42000000, "unit": "lovelace" },
      #                  "assets": [{"policy_id": "pid", "asset_name": "name", "quantity": 0 } ] } ])
      def random(wid, payments, withdrawal = nil, metadata = nil)
        Utils.verify_param_is_array!(payments)
        payments_formatted = if payments.any? { |p| p.key?(:address) || p.key?('address') }
                               payments
                             else
                               Utils.format_payments(payments)
                             end
        payload = { payments: payments_formatted }
        payload[:withdrawal] = withdrawal if withdrawal
        payload[:metadata] = metadata if metadata

        self.class.post("/wallets/#{wid}/coin-selections/random",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Coin selection -> Delegation action
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/selectCoins
      #
      # @example
      #   random(wid, {action: "join", pool: "poolid"})
      #   random(wid, {action: "quit"})
      def random_deleg(wid, deleg_action)
        Utils.verify_param_is_hash!(deleg_action)
        self.class.post("/wallets/#{wid}/coin-selections/random",
                        body: { delegation_action: deleg_action }.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end
    end

    # API for Transactions
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Transactions
    class Transactions < Base
      # Balance transaction
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/balanceTransaction
      # @param wid [String] source wallet id
      # @param payload [Hash] payload object
      def balance(wid, payload)
        self.class.post("/wallets/#{wid}/transactions-balance",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Decode transaction
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/decodeTransaction
      # @param wid [String] source wallet id
      # @param transaction [String] CBOR base64|base16 encoded transaction
      def decode(wid, transaction)
        payload = {}
        payload[:transaction] = transaction
        self.class.post("/wallets/#{wid}/transactions-decode",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Construct transaction
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/constructTransaction
      # @param wid [String] source wallet id
      # @param payments [Array of Hashes] full payments payload with assets
      # @param withdrawal [String or Array] 'self' or mnemonic sentence
      # @param metadata [Hash] special metadata JSON subset format (cf: https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/postTransaction)
      # @param mint [Array of Hashes] mint object
      # @param delegations [Array of Hashes] delegations object
      # @param validity_interval [Hash] validity_interval object
      def construct(wid,
                    payments = nil,
                    withdrawal = nil,
                    metadata = nil,
                    delegations = nil,
                    mint = nil,
                    validity_interval = nil)
        payload = {}
        payload[:payments] = payments if payments
        payload[:withdrawal] = withdrawal if withdrawal
        payload[:metadata] = metadata if metadata
        payload[:mint] = mint if mint
        payload[:delegations] = delegations if delegations
        payload[:validity_interval] = validity_interval if validity_interval

        self.class.post("/wallets/#{wid}/transactions-construct",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Sign transaction
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/signTransaction
      # @param wid [String] source wallet id
      # @param passphrase [String] wallet's passphrase
      # @param transaction [String] CBOR transaction data
      def sign(wid, passphrase, transaction)
        payload = {
          'passphrase' => passphrase,
          'transaction' => transaction
        }

        self.class.post("/wallets/#{wid}/transactions-sign",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Submit transaction
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/submitTransaction
      # @param wid [String] source wallet id
      # @param transaction [String] CBOR transaction data
      def submit(wid, transaction)
        payload = { 'transaction' => transaction }
        self.class.post("/wallets/#{wid}/transactions-submit",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Get tx by id
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getTransaction
      def get(wid, tx_id)
        self.class.get("/wallets/#{wid}/transactions/#{tx_id}")
      end

      # List all wallet's transactions
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/listTransactions
      #
      # @example
      #   list(wid, {start: "2012-09-25T10:15:00Z", order: "descending"})
      def list(wid, query = {})
        query_formatted = query.empty? ? '' : Utils.to_query(query)
        self.class.get("/wallets/#{wid}/transactions#{query_formatted}")
      end

      # Create a transaction from the wallet
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/postTransaction
      # @param wid [String] source wallet id
      # @param passphrase [String] source wallet's passphrase
      # @param payments [Array of Hashes] address / amount list or full payments payload with assets
      # @param withdrawal [String or Array] 'self' or mnemonic sentence
      # @param metadata [Hash] special metadata JSON subset format (cf: https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/postTransaction)
      # @param ttl [Int] transaction's time-to-live in seconds
      #
      # @example
      #   create(wid, passphrase, [{addr1: 1000000}, {addr2: 1000000}], 'self', {"1": "abc"}, ttl = 10)
      #   create(wid, passphrase, [{ "address": "addr1..",
      #                              "amount": { "quantity": 42000000, "unit": "lovelace" },
      #                              "assets": [{"policy_id": "pid", "asset_name": "name", "quantity": 0 } ] } ],
      #                              'self', {"1": "abc"}, ttl = 10)
      def create(wid, passphrase, payments, withdrawal = nil, metadata = nil, ttl = nil)
        Utils.verify_param_is_array!(payments)
        payments_formatted = if payments.any? { |p| p.key?(:address) || p.key?('address') }
                               payments
                             else
                               Utils.format_payments(payments)
                             end
        payload = { payments: payments_formatted,
                    passphrase: passphrase }
        payload[:withdrawal] = withdrawal if withdrawal
        payload[:metadata] = metadata if metadata
        payload[:time_to_live] = { quantity: ttl, unit: 'second' } if ttl

        self.class.post("/wallets/#{wid}/transactions",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Estimate fees for transaction
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/postTransactionFee
      #
      # @example
      #   payment_fees(wid, [{addr1: 1000000}, {addr2: 1000000}], {"1": "abc"}, ttl = 10)
      #   payment_fees(wid, [{ "address": "addr1..",
      #                        "amount": { "quantity": 42000000, "unit": "lovelace" },
      #                        "assets": [{"policy_id": "pid", "asset_name": "name", "quantity": 0 } ] } ],
      #                        {"1": "abc"}, ttl = 10)
      def payment_fees(wid, payments, withdrawal = nil, metadata = nil, ttl = nil)
        Utils.verify_param_is_array!(payments)
        payments_formatted = if payments.any? { |p| p.key?(:address) || p.key?('address') }
                               payments
                             else
                               Utils.format_payments(payments)
                             end

        payload = { payments: payments_formatted }

        payload[:withdrawal] = withdrawal if withdrawal
        payload[:metadata] = metadata if metadata
        payload[:time_to_live] = { quantity: ttl, unit: 'second' } if ttl

        self.class.post("/wallets/#{wid}/payment-fees",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Forget a transaction
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/deleteTransaction
      def forget(wid, txid)
        self.class.delete("/wallets/#{wid}/transactions/#{txid}")
      end
    end

    # API for StakePools
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Stake-Pools
    class StakePools < Base
      # Stake pools maintenance actions
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/postMaintenanceAction
      #
      # @example
      #   maintenance_action({ "maintenance_action": "gc_stake_pools" })
      def trigger_maintenance_actions(action = {})
        Utils.verify_param_is_hash!(action)
        self.class.post('/stake-pools/maintenance-actions',
                        body: action.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Metdata GC Status
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getMaintenanceActions
      def view_maintenance_actions
        self.class.get('/stake-pools/maintenance-actions')
      end

      # List all stake pools
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/listStakePools
      def list(stake = {})
        query = stake.empty? ? '' : Utils.to_query(stake)
        self.class.get("/stake-pools#{query}")
      end

      # List all stake keys
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/listStakeKeys
      def list_stake_keys(wid)
        self.class.get("/wallets/#{wid}/stake-keys")
      end

      # Join stake pool
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/joinStakePool
      def join(sp_id, wid, passphrase)
        self.class.put("/stake-pools/#{sp_id}/wallets/#{wid}",
                       body: { passphrase: passphrase }.to_json,
                       headers: { 'Content-Type' => 'application/json' })
      end

      # Quit stape pool
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/quitStakePool
      def quit(wid, passphrase)
        self.class.delete("#{@api}/stake-pools/*/wallets/#{wid}",
                          body: { passphrase: passphrase }.to_json,
                          headers: { 'Content-Type' => 'application/json' })
      end

      # Estimate delegation fees
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getDelegationFee
      def delegation_fees(wid)
        self.class.get("/wallets/#{wid}/delegation-fees")
      end
    end

    # Shelley migrations
    # @see https://input-output-hk.github.io/cardano-wallet/api/#tag/Migrations
    class Migrations < Base
      # Get migration plan
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/createShelleyWalletMigrationPlan
      def plan(wid, addresses)
        self.class.post("/wallets/#{wid}/migrations/plan",
                        body: { addresses: addresses }.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # Migrate all funds from Shelley wallet.
      # @see https://input-output-hk.github.io/cardano-wallet/api/#operation/migrateShelleyWallet
      # @param wid [String] wallet id
      # @param passphrase [String] wallet's passphrase
      # @param [Array] array of addresses
      def migrate(wid, passphrase, addresses)
        self.class.post("/wallets/#{wid}/migrations",
                        body: { addresses: addresses,
                                passphrase: passphrase }.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end
    end
  end
end
