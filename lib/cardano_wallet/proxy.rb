module CardanoWallet
  module Proxy

    # Call API for Proxy
    # @see https://input-output-hk.github.io/cardano-wallet/api/edge/#tag/Proxy
    def self.new(opt)
      Init.new opt
    end

    class Init < Base
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
