RSpec.describe CardanoWallet::Shelley do

  describe CardanoWallet::Shelley::Wallets do

    after(:each) do
      teardown
    end

    it "I can list wallets" do
      l = SHELLEY.wallets.list
      expect(l.code).to eq 200
      expect(l.size).to eq 0

      create_shelley_wallet
      l = SHELLEY.wallets.list
      expect(l.code).to eq 200
      expect(l.size).to eq 1
    end

    it "When wallet does not exist it gives 404" do
      wid = create_shelley_wallet
      SHELLEY.wallets.delete wid
      g = SHELLEY.wallets.get wid
      expect(g.code).to eq 404

      d = SHELLEY.wallets.delete wid
      expect(d.code).to eq 404
    end

    describe "Create wallets" do
      it "Create param must be hash" do
        w = SHELLEY.wallets
        expect{w.create("That's bad param")}.to raise_error ArgumentError, "argument should be Hash"
      end

      it "I can create, get and delete wallet from mnemonics" do
        w = SHELLEY.wallets
        wallet = w.create({name: "Wallet from mnemonic_sentence",
                           passphrase: "Secure Passphrase",
                           mnemonic_sentence: mnemonic_sentence("15"),
                           })
        expect(wallet.code).to eq 201
        wid = wallet['id']
        expect(w.get(wid).code).to eq 200
        expect(w.delete(wid).code).to eq 204
      end

      it "I can create, get and delete wallet from mnemonics / second factor" do
        w = SHELLEY.wallets
        wallet = w.create({name: "Wallet from mnemonic_sentence",
                           passphrase: "Secure Passphrase",
                           mnemonic_sentence: mnemonic_sentence("15"),
                           mnemonic_second_factor: mnemonic_sentence("12")
                           })
        expect(wallet.code).to eq 201
        wid = wallet['id']
        expect(w.get(wid).code).to eq 200
        expect(w.delete(wid).code).to eq 204
      end

      it "I can set address pool gap" do
        pool_gap = 55
        w = SHELLEY.wallets
        wallet = w.create({name: "Wallet from mnemonic_sentence",
                           passphrase: "Secure Passphrase",
                           mnemonic_sentence: mnemonic_sentence("15"),
                           address_pool_gap: pool_gap
                           })
        expect(wallet.code).to eq 201
        addr = SHELLEY.addresses.list(wallet['id'])
        expect(addr.code).to eq 200
        expect(addr.size).to eq pool_gap
      end

      it "I can create, get and delete wallet from pub key" do
        w = SHELLEY.wallets
        wallet = w.create({name: "Wallet from pub key",
                           account_public_key: "b47546e661b6c1791452d003d375756dde6cac2250093ce4630f16b9b9c0ac87411337bda4d5bc0216462480b809824ffb48f17e08d95ab9f1b91d391e48e66b",
                           address_pool_gap: 20,
                           })
        expect(wallet.code).to eq 201
        wid = wallet['id']
        expect(w.get(wid).code).to eq 200
        expect(w.delete(wid).code).to eq 204
      end
    end

    describe "Update wallet" do
      it "Can update_metadata" do
        new_name = "New wallet name"
        w = SHELLEY.wallets
        id = create_shelley_wallet
        expect(w.update_metadata(id, {name: new_name}).code).to eq 200
        expect(w.get(id)['name']).to eq new_name
      end

      it "Can update_passphrase" do
        w = SHELLEY.wallets
        id = create_shelley_wallet
        upd = w.update_passphrase(id,{old_passphrase: "Secure Passphrase",
                                      new_passphrase: "Securer Passphrase"})
        expect(upd.code).to eq 204
      end
    end

    it "Can see utxo" do
      id = create_shelley_wallet
      utxo = SHELLEY.wallets.utxo(id)
      expect(utxo.code).to eq 200
    end
  end

  describe CardanoWallet::Shelley::Addresses do

    after(:each) do
      teardown
    end

    it "Can list addresses" do
      id = create_shelley_wallet
      shelley_addr = CardanoWallet.new.shelley.addresses
      addresses = shelley_addr.list id
      expect(addresses.code).to eq 200
      expect(addresses.size).to eq 20

      addresses_unused = shelley_addr.list id, {state: "used"}
      expect(addresses_unused.code).to eq 200
      expect(addresses_unused.size).to eq 0

      addresses_unused = shelley_addr.list id, {state: "unused"}
      expect(addresses_unused.code).to eq 200
      expect(addresses_unused.size).to eq 20
    end
  end

  describe CardanoWallet::Shelley::CoinSelections do

    after(:each) do
      teardown
    end

    it "I could trigger random coin selection - if had money" do
      wid = create_shelley_wallet
      addresses = SHELLEY.addresses.list(wid)
      addr_amount =
         {addresses[0]['id'] => 123,
          addresses[1]['id'] => 456
         }

      rnd = SHELLEY.coin_selections.random wid, addr_amount
      expect(rnd.code).to eq 403
      expect(rnd).to include "not_enough_money"
    end

    it "ArgumentError on bad argument address_amount" do
      wid = create_shelley_wallet
      payments =[[{addr1: 1, addr2: 2}], "addr:123", 123]
      cs = SHELLEY.coin_selections
      payments.each do |p|
        expect{ cs.random(wid, p) }.to raise_error ArgumentError,
            "argument should be Hash"
      end
    end
  end

  describe CardanoWallet::Shelley::Transactions do

    after(:each) do
      teardown
    end

    it "I could get a tx if I had proper id" do
      wid = create_shelley_wallet
      txs = SHELLEY.transactions
      expect(txs.get(wid, TXID)).to include "no_such_transaction"
      expect(txs.get(wid, TXID).code).to eq 404
    end

    it "Can list transactions" do
      id = create_shelley_wallet
      txs = SHELLEY.transactions

      expect(txs.list(id).code).to eq 200
      expect(txs.list(id,
                      {start: "2012-09-25T10:15:00Z",
                       end: "2016-11-21T10:15:00Z",
                       order: "ascending"}).code).
                      to eq 200
      expect(txs.list(id, {order: "bad_order"}).code).to eq 400

    end

    it "I can send transaction and funds are received", :nightly => true  do
      amt = 1000000
      wid = create_fixture_shelley_wallet
      wait_for_shelley_wallet_to_sync(wid)
      target_id = create_shelley_wallet
      wait_for_shelley_wallet_to_sync(target_id)
      address = SHELLEY.addresses.list(target_id)[0]['id']

      tx_sent = SHELLEY.transactions.create(wid, PASS, {address => amt})
      expect(tx_sent.code).to eq 202

      eventually "Funds are on target wallet: #{target_id}" do
        available = SHELLEY.wallets.get(target_id)['balance']['available']['quantity']
        total = SHELLEY.wallets.get(target_id)['balance']['total']['quantity']
        (available == amt) && (total == amt)
      end
    end

    it "I can send transaction using 'withdrawal' flag and funds are received", :nightly => true  do
      amt = 1000000
      wid = create_fixture_shelley_wallet
      wait_for_shelley_wallet_to_sync(wid)
      target_id = create_shelley_wallet
      wait_for_shelley_wallet_to_sync(target_id)
      address = SHELLEY.addresses.list(target_id)[0]['id']

      tx_sent = SHELLEY.transactions.create(wid, PASS, {address => amt}, 'self')
      expect(tx_sent.code).to eq 202

      eventually "Funds are on target wallet: #{target_id}" do
        available = SHELLEY.wallets.get(target_id)['balance']['available']['quantity']
        total = SHELLEY.wallets.get(target_id)['balance']['total']['quantity']
        (available == amt) && (total == amt)
      end
    end

    it "I could create transaction - if I had money" do
      id = create_shelley_wallet
      target_id = create_shelley_wallet
      address = SHELLEY.addresses.list(target_id)[0]['id']
      txs = SHELLEY.transactions

      tx_sent = txs.create(id, PASS, {address => 1000000})
      expect(tx_sent).to include "not_enough_money"
      expect(tx_sent.code).to eq 403
    end

    it "I could create transaction using rewards - if I had money" do
      id = create_shelley_wallet
      target_id = create_shelley_wallet
      address = SHELLEY.addresses.list(target_id)[0]['id']
      txs = SHELLEY.transactions

      tx_sent = txs.create(id, PASS, {address => 1000000}, 'self')
      expect(tx_sent).to include "withdrawal_not_worth"
      expect(tx_sent.code).to eq 403
    end

    it "I could estimate transaction fee - if I had money" do
      id = create_shelley_wallet
      target_id = create_shelley_wallet
      address = SHELLEY.addresses.list(target_id)[0]['id']

      txs = SHELLEY.transactions

      fees = txs.payment_fees(id, {address => 1000000})
      expect(fees).to include "not_enough_money"
      expect(fees.code).to eq 403

      fees = txs.payment_fees(id, {address => 1000000}, 'self')
      expect(fees).to include "not_enough_money"
      expect(fees.code).to eq 403
    end

    it "I could forget transaction" do
      id = create_shelley_wallet
      txs = SHELLEY.transactions
      res = txs.forget(id, TXID)
      expect(res.code).to eq 404
    end
  end

  describe CardanoWallet::Shelley::StakePools do

    after(:each) do
      teardown
    end

    it "Can list stake pools only when stake is provided", :nightly => true do
      pools = SHELLEY.stake_pools
      expect(pools.list({stake: 1000}).code).to eq 200

      expect(pools.list).to include "query_param_missing"
      expect(pools.list.code).to eq 400
    end

    it "Can join and quit Stake Pool", :nightly => true do
      id = create_fixture_shelley_wallet
      wait_for_shelley_wallet_to_sync id
      #Get current active delegation if there is any
      #and don't use it when picking pool_id
      #otherwise the test could fail trying to join pool that wallet already joined
      pools = SHELLEY.stake_pools
      deleg = SHELLEY.wallets.get(id)['delegation']['active']
      if deleg['status'] == "delegating"
        current_pool_id = deleg['target']
        pool_id = (pools.list({stake: 1000}).map{|p| p['id']} - [current_pool_id]).sample
      else
        pool_id = pools.list({stake: 1000}).sample['id']
      end

      puts "Joining pool: #{pool_id}"
      join = pools.join(pool_id, id, PASS)
      expect(join).to include "status"
      expect(join.code).to eq 202

      join_tx_id = join['id']
      eventually "Checking if join tx id (#{join_tx_id}) is in_ledger" do
        tx = SHELLEY.transactions.get(id, join_tx_id)
        tx['status'] == "in_ledger"
      end

      puts "Quitting pool: #{pool_id}"
      quit = pools.quit(id, PASS)
      expect(quit).to include "status"
      expect(quit.code).to eq 202

      quit_tx_id = quit['id']
      eventually "Checking if join tx id (#{quit_tx_id}) is in_ledger" do
        tx = SHELLEY.transactions.get(id, quit_tx_id)
        tx['status'] == "in_ledger"
      end
    end

    # it "Can join all pools from cardano_cli", :nightly => true do
    #   id = create_fixture_shelley_wallet
    #   wait_for_shelley_wallet_to_sync id
    #
    #   pools = File.read("spec/pools.txt")
    #   pools.split.each do |pool_id|
    #     puts "Tryin to join pool: #{pool_id}"
    #     join = SHELLEY.stake_pools.join(pool_id, id, PASS)
    #     join_tx_id = join['id']
    #     puts join
    #     puts join_tx_id
    #     expect(join.code).to eq 202
    #     eventually "Checking if join transaction tx is in_ledger" do
    #       tx = SHELLEY.transactions.get(id, join_tx_id)
    #       tx['status'] == "in_ledger"
    #     end
    #   end
    #
    # end

    it "I could join Stake Pool - if I knew it's id" do
      id = create_shelley_wallet
      pools = SHELLEY.stake_pools

      join = pools.join(SPID, id, PASS)
      expect(join).to include "no_such_pool"
      expect(join.code).to eq 404
    end

    it "I could join Stake Pool - if I had enough to cover fee", :nightly => true do
      id = create_shelley_wallet
      pools = SHELLEY.stake_pools
      pool_id = pools.list({stake: 1000})[0]['id']

      join = pools.join(pool_id, id, PASS)
      expect(join).to include "cannot_cover_fee"
      expect(join.code).to eq 403
    end

    it "I could quit stake pool - if I was delegating" do
      id = create_shelley_wallet

      pools = SHELLEY.stake_pools
      quit = pools.quit(id, PASS)
      expect(quit).to include "not_delegating_to"
      expect(quit.code).to eq 403
    end

    it "I could check delegation fees - if I could cover fee" do
      id = create_shelley_wallet

      pools = SHELLEY.stake_pools
      fees = pools.delegation_fees(id)
      expect(fees).to include "cannot_cover_fee"
      expect(fees.code).to eq 403
    end
  end

  describe CardanoWallet::Shelley::Migrations do
    after(:each) do
      teardown
    end

    it "I could calculate migration cost" do
      id = create_shelley_wallet
      cost = SHELLEY.migrations.cost(id)
      expect(cost).to include "nothing_to_migrate"
      expect(cost.code).to eq 403
    end

    it "I could migrate all my funds" do
      id = create_shelley_wallet
      target_id = create_shelley_wallet
      addrs = SHELLEY.addresses.list(target_id).map{ |a| a['id'] }
      migr = SHELLEY.migrations.migrate(id, PASS, addrs)
      expect(migr).to include "nothing_to_migrate"
      expect(migr.code).to eq 403
    end
  end

end
