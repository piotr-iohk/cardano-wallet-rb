RSpec.describe CardanoWallet::Utils do
  it "to_query" do
    q = CardanoWallet::Utils.to_query({a: 1, b: 2})
    expect(q).to eq "?a=1&b=2"

    q = CardanoWallet::Utils.to_query({a: 1})
    expect(q).to eq "?a=1"

    expect{ CardanoWallet::Utils.to_query("BadArg") }.to raise_error ArgumentError,
      "argument should be Hash"
  end

  it "format_payments" do
    payments = CardanoWallet::Utils.format_payments([{a1: 1}, {a2: 2}])
    payments_expected =
      [
        {:address => "a1",
         :amount => {:quantity => 1,
                     :unit => "lovelace"}
        },
        {:address => "a2",
         :amount => {:quantity => 2,
                     :unit => "lovelace"}
        }
      ]
    expect(payments).to eq payments_expected

    payments = CardanoWallet::Utils.format_payments([{a1: 1}])
    payments_expected =
      [
        {:address => "a1",
         :amount => {:quantity => 1,
                     :unit => "lovelace"}
        }
      ]
    expect(payments).to eq payments_expected

    expect{ CardanoWallet::Utils.format_payments("BadArg") }.to raise_error ArgumentError,
      "argument should be Array"
  end

end
