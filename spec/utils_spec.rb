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
    payments = CardanoWallet::Utils.format_payments({a1: 1, a2: 2})
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

    payments = CardanoWallet::Utils.format_payments({a1: 1})
    payments_expected =
      [
        {:address => "a1",
         :amount => {:quantity => 1,
                     :unit => "lovelace"}
        }
      ]
    expect(payments).to eq payments_expected

    expect{ CardanoWallet::Utils.format_payments("BadArg") }.to raise_error ArgumentError,
      "argument should be Hash"
  end

  # it "test minUtxoValue" do
  #   wid = "1ceb45b37a94c7022837b5ca14045f11a5927c65" # shelley
  #   addr1 = "addr1qq5u7mrdu4vzywj6tz8gvlr0pzgrqgff5cx8z848j6et5da9e2ecu63lezzctl6fzaljdtjarcxt42pfwpckdyg6aq5samxkk4"
  #   addr2 = "addr1qpf3xjzchmnvp2q6lk7lm289dqekh66eumzh9ryguztdje99e2ecu63lezzctl6fzaljdtjarcxt42pfwpckdyg6aq5sr83cmj"
  #   addr3 = "addr1qr83quxe32jk0hx06qh90lc3gq3ewz72d957x0ncrpyyzta9e2ecu63lezzctl6fzaljdtjarcxt42pfwpckdyg6aq5sktrevg"
  #   addr4 = "addr1qpzmqg6572e35y8su3wz5mjjkqcwq3z9l3htxzfvtmcveq99e2ecu63lezzctl6fzaljdtjarcxt42pfwpckdyg6aq5skwk7un"
  #   shelley = CardanoWallet.new.shelley
  #   amt1 = 1000000
  #   amt2 = 999999
  #   amt3 = 1000000
  #   amt4 = 1000000
  #   h = {addr1 => amt1, addr2 => amt2}
  #   # t = shelley.transactions.create(wid, "Secure Passphrase", h)
  #   t = shelley.transactions.payment_fees(wid, h)
  #   uri = t.request.last_uri
  #   body = t.request.options[:body]
  #   method = t.request.http_method.to_s.split('::').last.upcase
  #   puts "#{method} #{uri}"
  #   puts body
  #   puts "--"
  #   puts t
  #
  #   expect(t.code).to eq 403
  #
  # end

  # it "import 130k addresses" do
  #   id = "0b3a38e4078206ccd93cc353a93cc3a37dbbb4fe"
  #   byron = CardanoWallet.new.byron
  #   f = File.readlines("spec/bulk/byron.yaml")
  #   addresses = f.map{|a| a.strip}
  #   puts "Start bulk import"
  #   r = byron.addresses.import(id, addresses)
  #   expect(r.code).to eq 204
  # end
  #
  # it "list 130k addresses" do
  #   id = "0b3a38e4078206ccd93cc353a93cc3a37dbbb4fe"
  #   byron = CardanoWallet.new.byron
  #   r = byron.addresses.list(id)
  #   expect(r.code).to eq 200
  #   expect(r.size).to eq 130000
  # end
end
