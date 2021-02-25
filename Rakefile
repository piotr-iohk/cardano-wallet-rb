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

task :win_setup_node_and_wallet do
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

  puts `#{install_node}`
  puts `#{install_wallet}`
  puts `#{start_node}`
  puts `#{start_wallet}`
end

task :unix_setup_node_and_wallet do
  desc "Set up and start cardano-node and cardano-wallet using screen tool"
  cd = Dir.pwd
  start_node = "#{cd}/cardano-node run --config #{cd}/spec/testnet/*-config.json --topology #{cd}/spec/testnet/*-topology.json --database-path #{ENV['NODE_DB']} --socket-path #{cd}/node.socket"
  start_wallet = "#{cd}/cardano-wallet serve --node-socket #{cd}/node.socket --testnet #{cd}/spec/testnet/*-byron-genesis.json --database #{ENV['WALLET_DB']} --token-metadata-server #{ENV['TOKEN_METADATA']}"

  puts start_node
  puts start_wallet

  puts `screen -dmS NODE #{start_node}`
  puts `screen -dmS WALLET #{start_wallet}`
  puts `screen -ls`
end

def wget(url)
  require 'httparty'
  file = Dir.pwd + "/spec/testnet/" + File.basename(url)
  resp = HTTParty.get(url)
  open(file, "wb") do |file|
    file.write(resp.body)
  end
  puts "#{url} -> #{resp.code}"
end

task :wget_configs, [:env] do |task, args|
  base_url = "https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1"
  env = args[:env]
  wget("#{base_url}/#{env}-config.json")
  wget("#{base_url}/#{env}-byron-genesis.json")
  wget("#{base_url}/#{env}-shelley-genesis.json")
  wget("#{base_url}/#{env}-topology.json")
end
