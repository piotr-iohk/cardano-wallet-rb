require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require_relative "lib/cardano_wallet"
task :wait_until_node_synced do
  desc "Wait for node to be synced"
  network = CardanoWallet.new.misc.network
  timeout = 180
  current_time = Time.now
  timeout_treshold = current_time + timeout
  puts "Timeout: #{timeout}s"
  puts "Threshold: #{timeout_treshold}"
  begin
    current_time = Time.now
    while network.information["sync_progress"]["status"] == "syncing" do
      puts "Syncing... #{network.information["sync_progress"]["progress"]["quantity"]}%"
      sleep 15
    end
  rescue
    retry if (current_time <= timeout_treshold)
    raise("Could not connect to wallet within #{timeout} seconds...")
  end

  puts ">> Cardano-node and cardano-wallet are synced! <<"
end

task :win_setup_nssm_services do
  desc "Set up and start cardano-node and cardano-wallet nssm services"
  cd = Dir.pwd

  # create cardano-node.bat file
  node_cmd = "#{cd}/cardano-node.exe run --config #{cd}/spec/testnet/testnet-config.json --topology #{cd}/spec/testnet/testnet-topology.json --database-path #{ENV['NODE_DB']} --socket-path \\\\.\\pipe\\cardano-node-testnet"
  File.open("cardano-node.bat", "w") do |f|
    f.write(node_cmd)
  end

  # create cardano-wallet.bat file
  wallet_cmd = "#{cd}/cardano-wallet.exe serve --node-socket \\\\.\\pipe\\cardano-node-testnet --testnet #{cd}/spec/testnet/testnet-byron-genesis.json --database #{ENV['WALLET_DB']} --token-metadata-server #{ENV['TOKEN_METADATA']}"
  File.open("cardano-wallet.bat", "w") do |f|
    f.write(wallet_cmd)
  end

  install_node = "nssm install cardano-node #{cd}/cardano-node.bat"
  install_wallet = "nssm install cardano-wallet #{cd}/cardano-wallet.bat"
  start_node = "nssm start cardano-node"
  start_wallet = "nssm start cardano-wallet"

  puts install_node
  puts install_wallet
  puts start_node
  puts start_wallet

  `#{install_node}`
  `#{install_wallet}`
  `#{start_node}`
  `#{start_wallet}`
end
