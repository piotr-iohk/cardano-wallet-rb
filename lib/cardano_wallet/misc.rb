module CardanoWallet
  module Misc

    def self.new(opt)
      Init.new opt
    end

    class Init < Base
      def initialize opt
        super
      end

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
    end

    # API for Network
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Network
    class Network < Base
      def initialize opt
        super
      end

      # Get network information
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getNetworkInformation
      def information
        self.class.get("/network/information")
      end

      # Check network clock
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getNetworkClock
      def clock
        self.class.get("/network/clock")
      end

      # Check network parameters
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/getNetworkParameters
      def parameters
        self.class.get("/network/parameters")
      end

    end

    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Utils
    class Utils < Base
      def initialize opt
        super
      end

      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/inspectAddress
      def addresses(address_id)
        self.class.get("/addresses/#{address_id}")
      end

    end

    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Proxy
    class Proxy < Base
      def initialize opt
        super
      end

      # Submit a transaction that was created and signed outside of cardano-wallet.
      # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#operation/postExternalTransaction
      # @param binary_blob [String] Signed transaction message binary blob.
      def submit_external_transaction(binary_blob)
        self.class.post("/proxy/transactions",
                        :body => binary_blob,
                        :headers => { 'Content-Type' => 'application/octet-stream' })
      end
    end
  end
end
