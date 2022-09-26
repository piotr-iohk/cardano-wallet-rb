# frozen_string_literal: true

require 'httparty'
require 'bip_mnemonic'

require_relative 'cardano_wallet/version'
require_relative 'cardano_wallet/base'
require_relative 'cardano_wallet/utils'
require_relative 'cardano_wallet/shelley'
require_relative 'cardano_wallet/byron'
require_relative 'cardano_wallet/misc'
require_relative 'cardano_wallet/shared'

##
# Main module
module CardanoWallet
  def self.new(options = {})
    CardanoWallet::Base.new(options)
  end
end
