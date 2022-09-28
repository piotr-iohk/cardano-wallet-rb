<a href="https://badge.fury.io/rb/cardano_wallet">
  <img src="https://badge.fury.io/rb/cardano_wallet.svg" alt="Gem Version">
</a>
<a href="https://github.com/piotr-iohk/cardano-wallet-rb/releases">
  <img src="https://img.shields.io/github/release/piotr-iohk/cardano-wallet-rb.svg" />
</a>
<a href="https://github.com/piotr-iohk/cardano-wallet-rb/actions?query=workflow%3ATests">
  <img src="https://github.com/piotr-iohk/cardano-wallet-rb/workflows/Tests/badge.svg" />
</a>


# cardano-wallet-rb

Ruby wrapper over [cardano-wallet's](https://github.com/input-output-hk/cardano-wallet) REST [API](https://input-output-hk.github.io/cardano-wallet/api/edge/). Requires running `cardano-wallet`.

Cardano-wallet-rb is used for e2e testing of [cardano-wallet](https://github.com/input-output-hk/cardano-wallet/test/e2e) and also as a backend of [Ikar](https://github.com/piotr-iohk/ikar).


## Installation

In Gemfile:

```ruby
gem 'cardano_wallet'
```

Or:

    $ gem install cardano_wallet

## Documentation

| Link | Description  |
|--|--|
|  [Ruby API (edge)](https://piotr-iohk.github.io/cardano-wallet-rb/master/) | cardano-wallet-rb API |
|[REST API (edge)](https://input-output-hk.github.io/cardano-wallet/api/edge/)| [cardano-wallet's](https://github.com/input-output-hk/cardano-wallet) REST API|

> :warning: Links point to `edge` APIs corresponding to `master` branches for both cardano-wallet and cardano-wallet-rb. Refer to release pages for API doc suitable for the latest release.

## Examples

```ruby
CW = CardanoWallet.new

BYRON = CW.byron
SHELLEY = CW.shelley
MISC = CW.misc

#Byron
BYRON.wallets.create({name: "Byron",
                       style: "random",
                       mnemonic_sentence: CW.utils.mnemonic_sentence,
                       passphrase: "Secure Passphrase"})

BYRON.wallets.list.each_with_index do |wal, i|
  BYRON.wallets.update_metadata(wal['id'], {name: "Wallet number #{i}"})
end

BYRON.wallets.list.each do |wal|
  puts wal['name']
end

#Shelley
w = SHELLEY.wallets.create({name: "Shelley",
                       mnemonic_sentence: CW.utils.mnemonic_sentence,
                       passphrase: "Secure Passphrase"})

SHELLEY.wallets.get(w['id'])
SHELLEY.wallets.delete(w['id'])

# Transaction
wid = '1f82e...ccd95'
metadata = { "1" => "test"}
tx_c = SHELLEY.transactions.construct(wid, payments = nil, withdrawal = nil, metadata)
tx_s = SHELLEY.transactions.sign(wid, 'Secure Passphrase', tx_c['transaction'])
tx_sub = SHELLEY.transactions.submit(wid, tx_s['transaction'])
puts SHELLEY.transactions.get(wid, tx_sub['id'])

# Delegation
wid = '1f82e...ccd95'
random_stake_pool_id = SHELLEY.stake_pools.list({stake: 10000}).sample['id']
delegation = [{
                "join" => {
                            "pool" => random_stake_pool_id,
                            "stake_key_index" => "0H"
                          }
              }]
tx_c = SHELLEY.transactions.construct(wid, payments = nil, withdrawal = nil, metadata = nil, delegation)
tx_s = SHELLEY.transactions.sign(wid, 'Secure Passphrase', tx_c['transaction'])
tx_sub = SHELLEY.transactions.submit(wid, tx_s['transaction'])
puts SHELLEY.transactions.get(wid, tx_sub['id'])

#Misc
MISC.network.information
MISC.network.clock
MISC.proxy.submit_external_transaction(File.new("/tmp/blob.bin").read)
MISC.utils.addresses("addr_test1vqrlltfahghjxl5sy5h5mvfrrlt6me5fqphhwjqvj5jd88cccqcek")
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/piotr-iohk/cardano-wallet-rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/piotr-iohk/cardano-wallet-rb/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `cardano-wallet-rb` project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/piotr-iohk/cardano-wallet-rb/blob/master/CODE_OF_CONDUCT.md).
