require "simplecov"
SimpleCov.start do
  add_filter %r{^/spec/}
end

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require "bip_mnemonic"
require "bundler/setup"
require "cardano_wallet"
# Helpers

PASS = "Secure Passphrase"
TXID = "1acf9c0f504746cbd102b49ffaf16dcafd14c0a2f1bbb23af265fbe0a04951cc"
SPID = "712dd028687560506e3b0b3874adbd929ab892591bfdee1221b5ee3796b79b70"
BYRON = CardanoWallet.new.byron
SHELLEY = CardanoWallet.new.shelley

def create_shelley_wallet
  SHELLEY.wallets.create({name: "Wallet from mnemonic_sentence",
                          passphrase: PASS,
                          mnemonic_sentence: mnemonic_sentence("15")
                         })['id']
end

def create_byron_wallet(style = "random")
  style == "random" ? mnem = mnemonic_sentence("12") : mnem = mnemonic_sentence("15")
  BYRON.wallets.create({style: style,
                        name: "Wallet from mnemonic_sentence",
                        passphrase: PASS,
                        mnemonic_sentence: mnem
                       })['id']
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

def mnemonic_sentence(word_count = "15")
  case word_count
    when '9'
      bits = 96
    when '12'
      bits = 128
    when '15'
      bits = 164
    when '18'
      bits = 196
    when '21'
      bits = 224
    when '24'
      bits = 256
    else
      raise "Non-supported no of words #{word_count}!"
  end
  BipMnemonic.to_mnemonic(bits: bits, language: 'english').split
end
