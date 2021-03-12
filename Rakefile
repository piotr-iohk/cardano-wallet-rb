require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'httparty'
require_relative 'lib/cardano_wallet'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

def wget(url, file = nil)
  file = File.basename(url) unless file
  resp = HTTParty.get(url)
  open(file, "wb") do |file|
    file.write(resp.body)
  end
  puts "#{url} -> #{resp.code}"
end

def mk_dir(path)
  Dir.mkdir(path) unless File.exists?(path)
end

task :get_latest_configs, [:env] do |task, args|
  puts "\n  >> Get latest configs for '#{args[:env]}'"

  base_url = "https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1"
  env = args[:env]
  path = Dir.pwd + "/configs"
  mk_dir(path)
  wget("#{base_url}/#{env}-config.json", "#{path}/#{env}-config.json")
  wget("#{base_url}/#{env}-byron-genesis.json", "#{path}/#{env}-byron-genesis.json")
  wget("#{base_url}/#{env}-shelley-genesis.json", "#{path}/#{env}-shelley-genesis.json")
  wget("#{base_url}/#{env}-topology.json", "#{path}/#{env}-topology.json")
end
