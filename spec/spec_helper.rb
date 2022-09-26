# frozen_string_literal: true

require 'simplecov'
require 'bundler/setup'
require 'cardano_wallet'
require 'bip_mnemonic'
require 'rspec/expectations'

SimpleCov.start do
  add_filter %r{^/spec/}
end

if ENV.fetch('CI', nil) == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec::Matchers.define :have_http do |code|
  match do |response|
    response.code == code
  end
  failure_message do |response|
    %(
          The response did not return expected HTTP code!
          Expected code = #{code}
          Actual code = #{response.code}
          Actual response:

          #{response}
        )
  end
end

CW = CardanoWallet.new
BYRON = CW.byron
SHELLEY = CW.shelley
UTILS = CW.utils

def create_shelley_wallet(name = 'Wallet from mnemonic_sentence')
  SHELLEY.wallets.create({ name: name,
                           passphrase: 'Secure Passphrase',
                           mnemonic_sentence: UTILS.mnemonic_sentence(24) })['id']
end

def create_byron_wallet(style = 'random', name = 'Wallet from mnemonic_sentence')
  BYRON.wallets.create({ style: style,
                         name: name,
                         passphrase: 'Secure Passphrase',
                         mnemonic_sentence: UTILS.mnemonic_sentence(24) })['id']
end

def teardown
  wb = BYRON.wallets
  wb.list.each do |w|
    wb.delete w['id']
  end

  ws = SHELLEY.wallets
  ws.list.each do |w|
    ws.delete w['id']
  end
end
