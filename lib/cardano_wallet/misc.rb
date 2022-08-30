# frozen_string_literal: true

module CardanoWallet
  ##
  # misc
  module Misc
    def self.new(opt)
      Init.new opt
    end

    ##
    # Base Class for Misc API
    class Init < Base
      # Call API for Network
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Network
      def network
        Network.new @opt
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Utils
      def utils
        Utils.new @opt
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Proxy
      def proxy
        Proxy.new @opt
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Settings
      def settings
        Settings.new @opt
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Node
      def node
        Node.new @opt
      end
    end

    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Node
    class Node < Base
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Node/paths/~1blocks~1latest~1header/get
      def block_header
        self.class.get('/blocks/latest/header')
      end

    end

    # API for Network
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Settings
    class Settings < Base
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getSettings
      def get
        self.class.get('/settings')
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/putSettings
      def update(params)
        CardanoWallet::Utils.verify_param_is_hash!(params)
        self.class.put('/settings',
                       body: { 'settings' => params }.to_json,
                       headers: { 'Content-Type' => 'application/json' })
      end
    end

    # API for Network
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Network
    class Network < Base
      # Get network information
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getNetworkInformation
      def information
        self.class.get('/network/information')
      end

      # Check network clock
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getNetworkClock
      def clock
        self.class.get('/network/clock')
      end

      # Check network parameters
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getNetworkParameters
      def parameters
        self.class.get('/network/parameters')
      end
    end

    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Utils
    class Utils < Base
      # @see https://input-output-hk.github.io/cardano-wallet/api/#operation/signMetadata
      def sign_metadata(wid, role, index, pass, metadata)
        payload = { passphrase: pass }
        payload[:metadata] = metadata if metadata

        self.class.post("/wallets/#{wid}/signatures/#{role}/#{index}",
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json' })
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/#operation/getWalletKey
      def get_public_key(wid, role, index)
        self.class.get("/wallets/#{wid}/keys/#{role}/#{index}")
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/inspectAddress
      def addresses(address_id)
        self.class.get("/addresses/#{address_id}")
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/postAnyAddress
      def post_address(payload)
        CardanoWallet::Utils.verify_param_is_hash!(payload)
        self.class.post('/addresses',
                        body: payload.to_json,
                        headers: { 'Content-Type' => 'application/json',
                                   'Accept' => 'application/json' })
      end

      # Current SMASH health
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getCurrentSmashHealth
      #
      # @example
      #   smash_health({url: "https://smash.cardano-mainnet.iohk.io/"})
      def smash_health(query = {})
        query_formatted = query.empty? ? '' : CardanoWallet::Utils.to_query(query)
        self.class.get("/smash/health#{query_formatted}")
      end
    end

    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Proxy
    class Proxy < Base
      # Submit a transaction that was created and signed outside of cardano-wallet.
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/postExternalTransaction
      # @param binary_blob [String] Signed transaction message binary blob.
      def submit_external_transaction(binary_blob)
        self.class.post('/proxy/transactions',
                        body: binary_blob,
                        headers: { 'Content-Type' => 'application/octet-stream' })
      end
    end
  end
end
