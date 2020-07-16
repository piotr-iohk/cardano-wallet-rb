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
# Artificial, non-existing id's
TXID = "1acf9c0f504746cbd102b49ffaf16dcafd14c0a2f1bbb23af265fbe0a04951cc"
SPID = "feea59bc6664572e631e9adfee77142cb51264156debf2e52970cc00"
###
BYRON = CardanoWallet.new.byron
SHELLEY = CardanoWallet.new.shelley
# timeout in seconds for custom verifications
TIMEOUT = 300

def create_shelley_wallet
  SHELLEY.wallets.create({name: "Wallet from mnemonic_sentence",
                          passphrase: PASS,
                          mnemonic_sentence: mnemonic_sentence("15")
                         })['id']
end

def get_fixture_shelley_wallet_tx_id
  # Existing and on fixture_shelley_wallet
  "7dc804eec7fd054dc59375c51620119e2a95fcb229c4f68eb57e566dcf80be5b"
end

def create_fixture_shelley_wallet
  # Wallet with funds on shelley testnet
  mnemonics = %w[shiver unknown lottery calm renew west any ecology merge slab sort color hybrid pact crowd]
  SHELLEY.wallets.create({name: "Fixture wallet with funds",
                          passphrase: PASS,
                          mnemonic_sentence: mnemonics
                         })['id']
end

def wait_for_shelley_wallet_to_sync(wid)
  puts "Syncing Shelley wallet..."
  while(SHELLEY.wallets.get(wid.to_s)['state']['status'] == "syncing") do
    puts "  Syncing... #{SHELLEY.wallets.get(wid)['state']['progress']['quantity']}%"
    sleep 5
  end
end

def create_byron_wallet_with(mnem, style = "random")
  BYRON.wallets.create({style: style,
                        name: "Wallet from mnemonic_sentence",
                        passphrase: PASS,
                        mnemonic_sentence: mnem
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

def get_fixture_byron_wallet_tx_id(style = "random")
  # Existing and on fixture_byron_wallet
  case style
  when "random"
    "a8d2228c05c9d2358ed6f2de92348d034d03aa58ad567ef4bcaf3dfd15b9c260"
  when "icarus"
    "723222e2fb28406311290d5d27c20e71d2f954706ba1d1405ec280f41918ad3b"
  end
end

def create_fixture_byron_wallet(style = "random")
  # Wallet with funds on shelley testnet
  case style
  when "random"
    mnemonics = %w[purchase carbon forest frog robot actual used news broken start plunge family]
  when "icarus"
    mnemonics = %w[security defense food inhale voyage tomorrow guess galaxy junior guilt vendor soon escape design pretty]
  end

  BYRON.wallets.create({style: style,
                        name: "Fixture byron wallets with funds",
                        passphrase: PASS,
                        mnemonic_sentence: mnemonics
                       })['id']
end

def wait_for_byron_wallet_to_sync(wid)
  puts "Syncing Byron wallet..."
  while BYRON.wallets.get(wid)['state']['status'] == "syncing" do
    puts "  Syncing... #{BYRON.wallets.get(wid)['state']['progress']['quantity']}%"
    sleep 5
  end
end

##
# wait until action passed as &block returns true or TIMEOUT is reached
def eventually(label, &block)
  current_time = Time.now
  timeout_treshold = current_time + TIMEOUT
  while(block.call == false) && (current_time <= timeout_treshold) do
    sleep 5
    current_time = Time.now
  end
  if (current_time > timeout_treshold)
    fail "Action '#{label}' did not resolve within timeout: #{TIMEOUT}s"
  end
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
