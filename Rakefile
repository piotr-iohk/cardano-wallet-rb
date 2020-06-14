require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require_relative "lib/cardano_wallet"
task :wait_until_node_synced do
  desc "Wait for node to be synced"
  network = CardanoWallet.new.misc.network
  while network.information["sync_progress"]["status"] == "syncing" do
    puts "Syncing... #{network.information["sync_progress"]["progress"]["quantity"]}%"
    sleep 15
  end
end
