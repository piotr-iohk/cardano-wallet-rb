RSpec.describe CardanoWallet::Shelley do

  MNEMONICS = %w[absurd seat ball together donate bulk sustain loop convince capital peanut mutual notice improve jewel]
  MNEMONICS2 = %w[vintage poem topic machine hazard cement dune glimpse fix brief account badge mass silly business]
  ADDRS = %w[addr1snt2ut07p5pcatwv73dr3qsrh3sjwmvme066khg2jvvtf9fhaen98psd5hpwkff894ydfquegwk6jwc7jrgaajvasftue49r25sl2kp6mew98t
             addr1ss8ju4alq5jl7rd92yczukcup4z7jnr97y8nqu4tvu4v7lukxngc60euugt6kvd3hdzply0hwpykd7nfdmssz0wm4255cht5rvhrgfr32q6ueh]
  PASS = "Secure Passphrase"
  TXID = "1acf9c0f504746cbd102b49ffaf16dcafd14c0a2f1bbb23af265fbe0a04951cc"
  SPID = "712dd028687560506e3b0b3874adbd929ab892591bfdee1221b5ee3796b79b70"

  def create_shelley_wallet
    CardanoWallet.new.shelley.wallets.
                  create({name: "Wallet from mnemonic_sentence",
                          passphrase: PASS,
                          mnemonic_sentence: MNEMONICS
                         })['id']
  end

  def delete_all
    ws = CardanoWallet.new.shelley.wallets
    ws.list.each do |w|
      ws.delete w['id']
    end
  end

  describe CardanoWallet::Shelley::Wallets do

    before(:all) do
      SHELLEY = CardanoWallet.new.shelley
    end

    after(:each) do
      delete_all
    end

    it "I can list wallets" do
      pending "Shelley wallets not supported yet"

      l = SHELLEY.wallets.list
      expect(l.code).to eq 200
    end

    it "I could get a wallet" do
      pending "Shelley wallets not supported yet"

      g = SHELLEY.wallets.get "db66f3d0d796c6aa0ad456a36d5a3ee88d62bd5d"
      expect(g.code).to eq 404
    end

    it "I could delete a wallet" do
      pending "Shelley wallets not supported yet"

      g = SHELLEY.wallets.delete "db66f3d0d796c6aa0ad456a36d5a3ee88d62bd5d"
      expect(g.code).to eq 404
    end

    it "I can create, get and delete wallet from mnemonics" do
      pending "Shelley wallets not supported yet"

      w = SHELLEY.wallets
      wallet = w.create({name: "Wallet from mnemonic_sentence",
                         passphrase: "Secure Passphrase",
                         mnemonic_sentence: MNEMONICS,
                         })
      expect(wallet.code).to eq 201
      wid = wallet['id']
      expect(w.get(wid).code).to eq 200
      expect(w.delete(wid).code).to eq 204
    end

    it "I can create, get and delete wallet from pub key" do
      pending "Shelley wallets not supported yet"

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

    it "Create param must be hash" do
      pending "Shelley wallets not supported yet"

      w = SHELLEY.wallets
      expect{w.create("That's bad param")}.to raise_error ArgumentError, "argument should be Hash"
    end

    it "Can update_metadata" do
      pending "Shelley wallets not supported yet"

      w = SHELLEY.wallets
      id = create_shelley_wallet
      expect(w.update_metadata(id,{name: "New wallet name"}).code).to eq 200
    end

    it "Can update_passphrase" do
      pending "Shelley wallets not supported yet"

      w = SHELLEY.wallets
      id = create_shelley_wallet
      upd = w.update_passphrase(id,{old_passphrase: "Secure Passphrase",
                                    new_passphrase: "Securer Passphrase"})
      expect(upd.code).to eq 204
    end

    it "Can see utxo" do
      pending "Shelley wallets not supported yet"

      id = create_shelley_wallet
      utxo = SHELLEY.wallets.utxo(id)
      expect(utxo.code).to eq 200
    end
  end

  describe CardanoWallet::Shelley::Addresses do

    after(:each) do
      delete_all
    end

    it "Can list addresses" do
      pending "Shelley wallets not supported yet"

      id = create_shelley_wallet
      shelley_addr = CardanoWallet.new.shelley.addresses
      addresses = shelley_addr.list id
      expect(addresses.code).to eq 200
      expect(addresses.size).to eq 30

      addresses_unused = shelley_addr.list id, {state: "used"}
      expect(addresses_unused.code).to eq 200
      expect(addresses_unused.size).to eq 10
    end
  end

  describe CardanoWallet::Shelley::CoinSelections do

    after(:each) do
      delete_all
    end

    it "Can trigger random coin selection" do
      pending "Shelley wallets not supported yet"

      wid = create_shelley_wallet
      addr_amount =
         {ADDRS[0] => 123,
          ADDRS[1] => 456
         }

      rnd = SHELLEY.coin_selections.random wid, addr_amount
      expect(rnd.code).to eq 200
    end

    it "ArgumentError on bad argument address_amount" do
      pending "Shelley wallets not supported yet"

      wid = "123123123"
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
      delete_all
    end

    it "Can list transactions" do
      pending "Shelley wallets not supported yet"

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

    it "Can create transaction" do
      pending "Shelley wallets not supported yet"

      id = create_shelley_wallet
      txs = SHELLEY.transactions

      tx_sent = txs.create(id, PASS, {ADDRS[0] => 1000000})
      expect(tx_sent.code).to eq 202
    end

    it "Can estimate fees" do
      pending "Shelley wallets not supported yet"

      id = create_shelley_wallet
      txs = SHELLEY.transactions

      fees = txs.payment_fees(id, {ADDRS[0] => 1000000})
      expect(fees.code).to eq 202
    end

    it "I could forget transaction" do
      pending "Shelley wallets not supported yet"

      id = create_shelley_wallet
      txs = SHELLEY.transactions
      res = txs.forget(id, TXID)
      expect(res.code).to eq 404
    end
  end

  describe CardanoWallet::Shelley::StakePools do

    after(:each) do
      delete_all
    end

    it "Can list stake pools" do
      pending "Shelley wallets not supported yet"

      pools = SHELLEY.stake_pools
      expect(pools.list.code).to eq 200
    end

    it "Can join stake pool" do
      pending "Shelley wallets not supported yet"

      id = create_shelley_wallet
      pools = SHELLEY.stake_pools
      join = pools.join(SPID, id, PASS)
      expect(join.code).to eq 202
    end

    it "I could quit stake pool" do
      pending "Shelley wallets not supported yet"

      id = SHELLEY.
             wallets.create({name: "Wallet from mnemonic_sentence",
                             passphrase: PASS,
                             mnemonic_sentence: MNEMONICS2
                             })['id']
      pools = SHELLEY.stake_pools
      quit = pools.quit(id, PASS)
      expect(quit.code).to eq 403
    end

    it "Can check delegation fees" do
      pending "Shelley wallets not supported yet"

      id = create_shelley_wallet
      pools = SHELLEY.stake_pools
      fees = pools.delegation_fees id
      expect(fees.code).to eq 200
    end
  end

  describe CardanoWallet::Shelley::Migrations do
    after(:each) do
      delete_all
    end

    it "I could calculate migration cost" do
      pending "Shelley wallets not supported yet"

      id = create_shelley_wallet
      cost = SHELLEY.migrations.cost(id)
      expect(cost.code).to eq 403
    end

    it "I could migrate all my funds" do
      pending "Shelley wallets not supported yet"
      
      id = create_shelley_wallet
      migr = SHELLEY.migrations.migrate(id, PASS, ADDRS)
      expect(migr.code).to eq 501
    end
  end

end
