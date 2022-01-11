# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'httparty'
require_relative 'lib/cardano_wallet'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

def wget(url, file = nil)
  file ||= File.basename(url)
  resp = HTTParty.get(url)
  File.binwrite(file, resp.body)
  puts "#{url} -> #{resp.code}"
end

def mk_dir(path)
  Dir.mkdir(path) unless File.exist?(path)
end

task :get_latest_configs, [:env] do |_, args|
  puts "\n  >> Get latest configs for '#{args[:env]}'"

  base_url = 'https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1'
  env = args[:env]
  path = File.join(Dir.pwd, 'configs')
  mk_dir(path)
  wget("#{base_url}/#{env}-config.json", "#{path}/#{env}-config.json")
  wget("#{base_url}/#{env}-byron-genesis.json", "#{path}/#{env}-byron-genesis.json")
  wget("#{base_url}/#{env}-alonzo-genesis.json", "#{path}/#{env}-alonzo-genesis.json")
  wget("#{base_url}/#{env}-shelley-genesis.json", "#{path}/#{env}-shelley-genesis.json")
  wget("#{base_url}/#{env}-topology.json", "#{path}/#{env}-topology.json")
end
