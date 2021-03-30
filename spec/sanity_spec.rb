# frozen_string_literal: true

RSpec.describe 'Sanity suite' do
  after(:each) do
    teardown
  end

  it 'Can set custom headers like X-Max-Safe-Integer' do
    custom_headers = { 'X-Max-Safe-Integer' => '0' }
    n = CardanoWallet.new({ headers: custom_headers }).misc.network.information
    expect(n.code).to eq 200
    expect(n['node_tip']['absolute_slot_number']).to satisfy('be string') do |q|
      q.instance_of?(String)
    end
    expect(n.request.options[:headers]).to eq custom_headers
  end

  it 'Can init with default params' do
    n = CardanoWallet.new.misc.network.information
    expect(n.code).to eq 200
  end

  it 'Can init with port' do
    n = CardanoWallet.new({ port: 8090 }).misc.network.information
    expect(n.code).to eq 200
  end

  it 'Can init with url' do
    n = CardanoWallet.new({ url: 'http://localhost:8090/v2' }).misc.network.information
    expect(n.code).to eq 200
  end

  it 'Can set protocol' do
    n = CardanoWallet.new({ protocol: 'http', port: 8090 }).misc.network.information
    expect(n.code).to eq 200
  end

  it 'Can set timeout' do
    n = CardanoWallet.new({ timeout: 120, port: 8090 }).misc.network.information
    expect(n.code).to eq 200
  end

  it 'I can list wallets - Shelley' do
    l = SHELLEY.wallets.list
    expect(l.code).to eq 200
    expect(l.size).to eq 0

    create_shelley_wallet
    l = SHELLEY.wallets.list
    expect(l.code).to eq 200
    expect(l.size).to eq 1
  end

  it 'I can list wallets - Byron' do
    l = BYRON.wallets.list
    expect(l.code).to eq 200
    expect(l.size).to eq 0

    create_byron_wallet
    l = BYRON.wallets.list
    expect(l.code).to eq 200
    expect(l.size).to eq 1
  end

  it 'I can create, get and delete wallet - Shelley' do
    w = SHELLEY.wallets
    wallet = w.create({ name: 'Wallet from mnemonic_sentence',
                        passphrase: 'Secure Passphrase',
                        mnemonic_sentence: mnemonic_sentence(24) })
    expect(wallet.code).to eq 201
    wid = wallet['id']
    expect(w.get(wid).code).to eq 200
    expect(w.delete(wid).code).to eq 204
  end

  it 'I can create, get and delete byron icarus wallet' do
    wallet = BYRON.wallets.create({ style: 'icarus',
                                    name: 'Wallet from mnemonic_sentence',
                                    passphrase: 'Secure Passphrase',
                                    mnemonic_sentence: mnemonic_sentence(15) })
    expect(wallet).to have_http 201
    wid = wallet['id']
    expect(BYRON.wallets.get(wid)).to have_http 200
    expect(BYRON.wallets.delete(wid)).to have_http 204
  end

  it 'I can create, get and delete byron random wallet from mnemonics' do
    wallet = BYRON.wallets.create({ style: 'random',
                                    name: 'Wallet from mnemonic_sentence',
                                    passphrase: 'Secure Passphrase',
                                    mnemonic_sentence: mnemonic_sentence(12) })
    expect(wallet).to have_http 201
    wid = wallet['id']
    expect(BYRON.wallets.get(wid)).to have_http 200
    expect(BYRON.wallets.delete(wid)).to have_http 204
  end
end
