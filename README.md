# CardanoWallet

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

```ruby
# Can use with default options
CardanoWallet.new.misc.network.information

# Can use with custom options
CW1 = CardanoWallet.new({port: 8091})
CW2 = CardanoWallet.new({port: 443,
                        protocol: "https",
                        cacert: "/root/ca.cert",
                        pem: "/root/client.pem"})

CW1.byron.wallets.list
CW2.shelley.wallets.create{name: "Wallet1",
                           mnemonic_sentence: mnemonics,
                           passphrase: "Secure Passphrase"}

```

Refer to documentation or have a look at icarus for reference.

## Development

 - Make sure tests are passing (`rake`)
 - Develop and add tests
 - Make sure tests are passing (`rake`)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cardano_wallet. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/cardano_wallet/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CardanoWallet project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/cardano_wallet/blob/master/CODE_OF_CONDUCT.md).
