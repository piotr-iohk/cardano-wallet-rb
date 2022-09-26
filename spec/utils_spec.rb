# frozen_string_literal: true

RSpec.describe CardanoWallet::Utils do
  it 'mnemonic_sentence default' do
    expect(UTILS.mnemonic_sentence.size).to eq 24
  end

  it 'mnemonic_sentence OK' do
    languages = %w[english french spanish korean japanese
                   italian chinese_traditional chinese_simplified]
    words = [9, 12, 15, 18, 21, 24]

    languages.each do |l|
      words.each do |w|
        s = UTILS.mnemonic_sentence(w, l)
        expect(s.size).to eq w
      end
    end
  end

  it 'mnemonic_sentence raise' do
    expect do
      UTILS.mnemonic_sentence(8)
    end.to raise_error ArgumentError,
                       /Not supported count of words 8. Supported counts are:/
    expect do
      UTILS.mnemonic_sentence(15,
                              'spanglish')
    end.to raise_error ArgumentError,
                       /Not supported language: 'spanglish'. Supported languages are:/
  end

  it 'to_query' do
    q = CardanoWallet::Utils.to_query({ a: 1, b: 2 })
    expect(q).to eq '?a=1&b=2'

    q = CardanoWallet::Utils.to_query({ a: 1 })
    expect(q).to eq '?a=1'

    expect { CardanoWallet::Utils.to_query('BadArg') }.to raise_error ArgumentError,
                                                                      'argument should be Hash'
  end

  it 'format_payments' do
    payments = CardanoWallet::Utils.format_payments([{ a1: 1 }, { a2: 2 }])
    payments_expected =
      [
        { address: 'a1',
          amount: { quantity: 1,
                    unit: 'lovelace' } },
        { address: 'a2',
          amount: { quantity: 2,
                    unit: 'lovelace' } }
      ]
    expect(payments).to eq payments_expected

    payments = CardanoWallet::Utils.format_payments([{ a1: 1 }])
    payments_expected =
      [
        { address: 'a1',
          amount: { quantity: 1,
                    unit: 'lovelace' } }
      ]
    expect(payments).to eq payments_expected

    expect { CardanoWallet::Utils.format_payments('BadArg') }.to raise_error ArgumentError,
                                                                             'argument should be Array'
  end
end
