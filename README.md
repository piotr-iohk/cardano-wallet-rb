<a href="https://github.com/piotr-iohk/cardano-wallet-rb/releases">
  <img src="https://img.shields.io/github/release/piotr-iohk/cardano-wallet-rb.svg" />
</a>
<a href="https://codecov.io/gh/piotr-iohk/cardano-wallet-rb">
  <img src="https://codecov.io/gh/piotr-iohk/cardano-wallet-rb/branch/master/graph/badge.svg?token=OmUMUeyR21" />
</a>
<a href="https://github.com/piotr-iohk/cardano-wallet-rb/actions?query=workflow%3ATests">
  <img src="https://github.com/piotr-iohk/cardano-wallet-rb/workflows/Tests/badge.svg" />
</a>

# cardano-wallet-rb

Ruby wrapper over [cardano-wallet's](https://github.com/input-output-hk/cardano-wallet) REST [API](https://input-output-hk.github.io/cardano-wallet/api/edge/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cardano_wallet'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cardano_wallet

## Usage

### Initialize

```ruby
# default options
CW = CardanoWallet.new

# custom options
CW1 = CardanoWallet.new({port: 8091})
CW2 = CardanoWallet.new({port: 443,
                        protocol: "https",
                        cacert: "/root/ca.cert",
                        pem: "/root/client.pem"})
```
### Excercise the API
```ruby
CW = CardanoWallet.new

BYRON = CW.byron
SHELLEY = CW.shelley
MISC = CW.misc
PROXY = CW.proxy

#Byron
BYRON.wallets.list.each_with_index do |wal, i|
  BYRON.wallets.update_metadata(wal['id'], {name: "Wallet number #{i}"})
end

#Shelley
w = SHELLEY.wallets.create{name: "Wallet1",
	                       mnemonic_sentence: %w[vintage poem topic machine hazard cement dune glimpse fix brief account badge mass silly business],
	                       passphrase: "Secure Passphrase"}

SHELLEY.wallets.get(w['id'])

#Misc
MISC.network.information
MISC.network.clock

#Proxy
PROXY.submit_external_transaction(File.new("/tmp/blob.bin").read)
```

Refer to documentation.

## Development

In order to spin up environment for development and testing `docker-compose` can be used.

    $ NETWORK=testnet WALLET=dev-master-byron NODE=latest docker-compose up --detach

This starts:
  - `cardano-node` latest [release](https://github.com/input-output-hk/cardano-node/releases)
  - `cardano-wallet-byron` [master](https://github.com/input-output-hk/cardano-wallet)

Run tests on top of that:

    $ rake


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/piotr-iohk/cardano-wallet-rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/piotr-iohk/cardano-wallet-rb/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `cardano-wallet-rb` project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/piotr-iohk/cardano-wallet-rb/blob/master/CODE_OF_CONDUCT.md).
