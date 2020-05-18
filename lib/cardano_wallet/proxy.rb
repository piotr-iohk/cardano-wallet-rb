module CardanoWallet
  module Proxy

    def self.new(opt)
      Init.new opt
    end

    class Init < Base
      def initialize opt
        super
      end

      def submit_external_transaction
        Network.new @opt
      end
    end

  end
end
