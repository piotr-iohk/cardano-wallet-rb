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
      #   random(wid, {address1: 123, address2: 456})
      def random(wid, payments)
        payments_formatted = Utils.format_payments(payments)
        self.class.post("/wallets/#{wid}/coin-selections/random",
                        :body => {:payments => payments_formatted}.to_json,
                        :headers => { 'Content-Type' => 'application/json' })
      end
    end

    # API for Transactions
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Transactions
    class Transactions < Base
      def initialize opt
        super
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
      # @param payments [Hash] addres, amount pair
      #
      # @example
      #   create(wid, passphrase, {addr1: 1000000})
      def create(wid, passphrase, payments)
        payments_formatted = Utils.format_payments(payments)
        self.class.post("/wallets/#{wid}/transactions",
        :body => { :payments => payments_formatted,
                   :passphrase => passphrase
                 }.to_json,
        :headers => { 'Content-Type' => 'application/json' } )

      end

      # Estimate fees for transaction
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/postTransactionFee
      #
      # @example
      #   payment_fees(wid, {addr1: 1000000})
      def payment_fees(wid, payments)
        payments_formatted = Utils.format_payments(payments)
        self.class.post("/wallets/#{wid}/payment-fees",
        :body => { :payments => payments_formatted }.to_json,
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

      # List all stake pools
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/listStakePools
      def list(wid)
        self.class.get("/wallets/#{wid}/stake-pools")
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
