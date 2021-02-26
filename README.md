

<a href="https://badge.fury.io/rb/cardano_wallet">
  <img src="https://badge.fury.io/rb/cardano_wallet.svg" alt="Gem Version">
</a>
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

## Nightly tests

Cardano-wallet-rb is used for e2e testing of [cardano-wallet](https://github.com/input-output-hk/cardano-wallet) against public testnet.

|Platform|Status  |
|--|--|
|Docker  | <a href="https://github.com/piotr-iohk/cardano-wallet-rb/actions/workflows/nightly-docker.yml?query=workflow%3ANightly"><img src="https://github.com/piotr-iohk/cardano-wallet-rb/workflows/Nightly%20Docker/badge.svg" /></a> |
|Linux  | <a href="https://github.com/piotr-iohk/cardano-wallet-rb/actions/workflows/nightly-linux.yml?query=workflow%3ANightly"><img src="https://github.com/piotr-iohk/cardano-wallet-rb/workflows/Nightly%20Linux/badge.svg" /></a> |
|MacOS  | <a href="https://github.com/piotr-iohk/cardano-wallet-rb/actions/workflows/nightly-macos.yml?query=workflow%3ANightly"><img src="https://github.com/piotr-iohk/cardano-wallet-rb/workflows/Nightly%20MacOS/badge.svg" /></a> |
|Windows  | <a href="https://github.com/piotr-iohk/cardano-wallet-rb/actions/workflows/nightly-windows.yml?query=workflow%3ANightly"><img src="https://github.com/piotr-iohk/cardano-wallet-rb/workflows/Nightly%20Windows/badge.svg" /></a> |


## Installation

In Gemfile:

```ruby
gem 'cardano_wallet'
```

Or:

    $ gem install cardano_wallet

## Documentation

For ruby doc see: https://rubydoc.info/gems/cardano_wallet.

For `cardano-wallet` REST Api see: https://input-output-hk.github.io/cardano-wallet/api/edge/.

## Usage

```ruby
CW = CardanoWallet.new

BYRON = CW.byron
SHELLEY = CW.shelley
MISC = CW.misc

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
MISC.proxy.submit_external_transaction(File.new("/tmp/blob.bin").read)
MISC.utils.addresses("addr_test1vqrlltfahghjxl5sy5h5mvfrrlt6me5fqphhwjqvj5jd88cccqcek")
```

Refer to [documentation](https://rubydoc.info/gems/cardano_wallet) for more details.

## Development

In order to spin up environment for development and testing `docker-compose` can be used. For instance:

    # Byron testnet
    $ NETWORK=testnet WALLET=dev-master-byron NODE=latest docker-compose up --detach

or

    # Shelley testnet
    $ NODE=1.13.0 WALLET=dev-master-shelley NODE_CONFIG_PATH=`pwd`/spec/shelley-testnet/ docker-compose -f docker-compose-shelley.yml up

Run tests on top of that:

    $ rake

Clean up docker stuff after, e.g.:

    $ NETWORK=... docker-compose down --rmi all --remove-orphans

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/piotr-iohk/cardano-wallet-rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/piotr-iohk/cardano-wallet-rb/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `cardano-wallet-rb` project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/piotr-iohk/cardano-wallet-rb/blob/master/CODE_OF_CONDUCT.md).
