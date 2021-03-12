require_relative 'lib/cardano_wallet/version'

Gem::Specification.new do |spec|
  spec.name          = "cardano_wallet"
  spec.version       = CardanoWallet::VERSION
  spec.authors       = ["Piotr Stachyra"]
  spec.email         = ["piotr.stachyra@gmail.com"]

  spec.summary       = %q{Ruby wrapper over cardano-wallet.}
  spec.description   = %q{Ruby wrapper over cardano-wallet.}
  spec.homepage      = "https://github.com/piotr-iohk/cardano-wallet-rb"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'httparty', '~> 0.18.0'

  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'codecov', '0.2.8'
  spec.add_development_dependency 'simplecov'

end
