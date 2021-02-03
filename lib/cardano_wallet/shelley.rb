module CardanoWallet
  # Init API for Shelley
  module Shelley

    def self.new(opt)
      Init.new opt
    end

    class Init < Base

      def initialize opt
        super
      end

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

    class Assets < Base
      def initialize opt
        super
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

    class Keys < Base
      def initialize opt
        super
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/#operation/signMetadata
      def sign_metadata(wid, role, index, pass, metadata)
        payload = { passphrase: pass }
        payload[:metadata] = metadata if metadata

        self.class.post("/wallets/#{wid}/signatures/#{role}/#{index}",
                        :body => payload.to_json,
                        :headers => { 'Content-Type' => 'application/json',
                                      'Accept' => 'application/octet-stream'} )
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/#operation/getWalletKey
      def get_public_key(wid, role, index)
        self.class.get("/wallets/#{wid}/keys/#{role}/#{index}")
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/#operation/postAccountKey
      def create_acc_public_key(wid, index, pass, extended)
        payload = { passphrase: pass, extended: extended }
        self.class.post("/wallets/#{wid}/keys/#{index}",
                        :body => payload.to_json,
                        :headers => { 'Content-Type' => 'application/json' }
                        )
      end

    end

    # API for Wallets
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Wallets
    class Wallets < Base
      def initialize opt
        super
      end

      # List all wallets
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/listWallets
      def list
        self.class.get("/wallets")
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
      #           mnemonic_sentence: %w[story egg fun dismiss gasp mad spoon human cloud become garbage panel rhythm knee help],
      #          })
      # @example Create wallet from pub key
      #   create({name: "Wallet from pub key",
      #           account_public_key: "b47546e661b6c1791452d003d375756dde6cac2250093ce4630f16b9b9c0ac87411337bda4d5bc0216462480b809824ffb48f17e08d95ab9f1b91d391e48e66b",
      #           address_pool_gap: 20,
      #          })
      def create(params)
        Utils.verify_param_is_hash!(params)
        self.class.post( "/wallets",
                         :body => params.to_json,
                         :headers => { 'Content-Type' => 'application/json' }
                        )
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
                       :body => params.to_json,
                       :headers => { 'Content-Type' => 'application/json' }
                      )
      end

      # See wallet's utxo distribution
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getUTxOsStatistics
      def utxo(wid)
        self.class.get("/wallets/#{wid}/statistics/utxos")
      end

      # Update wallet's passphrase
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/putWalletPassphrase
      #
      # @example
      #   update_passphrase(wid, {old_passphrase: "Secure Passphrase", new_passphrase: "Securer Passphrase"})
      def update_passphrase(wid, params)
        Utils.verify_param_is_hash!(params)
        self.class.put("/wallets/#{wid}/passphrase",
                       :body => params.to_json,
                       :headers => { 'Content-Type' => 'application/json' }
                      )
      end
    end

    # API for Addresses
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Addresses
    class Addresses < Base
      def initialize opt
        super
      end

      # List addresses
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/listAddresses
      #
      # @example
      #   list(wid, {state: "used"})
      def list(wid, q = {})
        q.empty? ? query = '' : query = Utils.to_query(q)
        self.class.get("/wallets/#{wid}/addresses#{query}")
      end
    end

    # API for CoinSelections
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Coin-Selections
    class CoinSelections < Base
      def initialize opt
        super
      end

      # Show random coin selection for particular payment
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/selectCoins
      #
      # @example
      #   random(wid, [{addr1: 1000000}, {addr2: 1000000}])
      #   random(wid, [{ "address": "addr1..", "amount": { "quantity": 42000000, "unit": "lovelace" }, "assets": [{"policy_id": "pid", "asset_name": "name", "quantity": 0 } ] } ])
      def random(wid, payments)
        Utils.verify_param_is_array!(payments)
        if payments.any?{|p| p.has_key?("address".to_sym) || p.has_key?("address")}
          payments_formatted = payments
        else
          payments_formatted = Utils.format_payments(payments)
        end
        self.class.post("/wallets/#{wid}/coin-selections/random",
                        :body => {:payments => payments_formatted}.to_json,
                        :headers => { 'Content-Type' => 'application/json' })
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
                        :body => {:delegation_action => deleg_action}.to_json,
                        :headers => { 'Content-Type' => 'application/json' })
      end
    end

    # API for Transactions
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Transactions
    class Transactions < Base
      def initialize opt
        super
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
      def list(wid, q = {})
        q.empty? ? query = '' : query = Utils.to_query(q)
        self.class.get("/wallets/#{wid}/transactions#{query}")
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
      #   create(wid, passphrase, [{ "address": "addr1..", "amount": { "quantity": 42000000, "unit": "lovelace" }, "assets": [{"policy_id": "pid", "asset_name": "name", "quantity": 0 } ] } ], 'self', {"1": "abc"}, ttl = 10)
      def create(wid, passphrase, payments, withdrawal = nil, metadata = nil, ttl = nil)
        Utils.verify_param_is_array!(payments)
        if payments.any?{|p| p.has_key?("address".to_sym) || p.has_key?("address")}
          payments_formatted = payments
        else
          payments_formatted = Utils.format_payments(payments)
        end
        payload = { :payments => payments_formatted,
                    :passphrase => passphrase
                  }
        payload[:withdrawal] = withdrawal if withdrawal
        payload[:metadata] = metadata if metadata
        payload[:time_to_live] = { quantity: ttl, unit: "second" } if ttl

        self.class.post("/wallets/#{wid}/transactions",
        :body => payload.to_json,
        :headers => { 'Content-Type' => 'application/json' } )
      end

      # Estimate fees for transaction
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/postTransactionFee
      #
      # @example
      #   payment_fees(wid, [{addr1: 1000000}, {addr2: 1000000}], {"1": "abc"}, ttl = 10)
      #   payment_fees(wid, [{ "address": "addr1..", "amount": { "quantity": 42000000, "unit": "lovelace" }, "assets": [{"policy_id": "pid", "asset_name": "name", "quantity": 0 } ] } ], {"1": "abc"}, ttl = 10)
      def payment_fees(wid, payments, withdrawal = nil, metadata = nil, ttl = nil)
        Utils.verify_param_is_array!(payments)
        if payments.any?{|p| p.has_key?("address".to_sym) || p.has_key?("address")}
          payments_formatted = payments
        else
          payments_formatted = Utils.format_payments(payments)
        end

        payload = { :payments => payments_formatted }

        payload[:withdrawal] = withdrawal if withdrawal
        payload[:metadata] = metadata if metadata
        payload[:time_to_live] = { quantity: ttl, unit: "second" } if ttl

        self.class.post("/wallets/#{wid}/payment-fees",
        :body => payload.to_json,
        :headers => { 'Content-Type' => 'application/json' } )
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
      def initialize opt
        super
      end

      # Stake pools maintenance actions
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/postMaintenanceAction
      #
      # @example
      #   maintenance_action({ "maintenance_action": "gc_stake_pools" })
      def trigger_maintenance_actions(action = {})
        Utils.verify_param_is_hash!(action)
        self.class.post("/stake-pools/maintenance-actions",
          :body => action.to_json,
          :headers => { 'Content-Type' => 'application/json' } )
      end

      # Metdata GC Status
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getMaintenanceActions
      def view_maintenance_actions
        self.class.get("/stake-pools/maintenance-actions")
      end

      # List all stake pools
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/listStakePools
      def list(stake = {})
        stake.empty? ? query = '' : query = Utils.to_query(stake)
        self.class.get("/stake-pools#{query}")
      end

      # Join stake pool
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/joinStakePool
      def join(sp_id, wid, passphrase)
        self.class.put("/stake-pools/#{sp_id}/wallets/#{wid}",
        :body => { :passphrase => passphrase }.to_json,
        :headers => { 'Content-Type' => 'application/json' } )
      end

      # Quit stape pool
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/quitStakePool
      def quit(wid, passphrase)
        self.class.delete("#{@api}/stake-pools/*/wallets/#{wid}",
        :body => { :passphrase => passphrase }.to_json,
        :headers => { 'Content-Type' => 'application/json' } )
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
      def initialize opt
        super
      end

      # Calculate migration cost
      # @see https://input-output-hk.github.io/cardano-wallet/api/#operation/getShelleyWalletMigrationInfo
      def cost(wid)
        self.class.get("/wallets/#{wid}/migrations")
      end

      # Migrate all funds from Shelley wallet.
      # @see https://input-output-hk.github.io/cardano-wallet/api/#operation/migrateShelleyWallet
      # @param wid [String] wallet id
      # @param passphrase [String] wallet's passphrase
      # @param [Array] array of addresses
      def migrate(wid, passphrase, addresses)
        self.class.post("/wallets/#{wid}/migrations",
        :body => { :addresses => addresses,
                   :passphrase => passphrase
                 }.to_json,
        :headers => { 'Content-Type' => 'application/json' } )
      end

    end
  end
end
