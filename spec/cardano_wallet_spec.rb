RSpec.describe CardanoWallet do
  it "has a version number" do
    expect(CardanoWallet::VERSION).not_to be nil
  end

  describe CardanoWallet::Base do
      it "Can init with default params" do
        n = CardanoWallet.new.misc.network.information
        expect(n.code).to eq 200
      end

      it "Can init with port" do
        n = CardanoWallet.new({port: 8090}).misc.network.information
        expect(n.code).to eq 200
      end

      it "Can init with url" do
        n = CardanoWallet.new({url: "http://localhost:8090/v2"}).misc.network.information
        expect(n.code).to eq 200
      end

      it "Can set protocol" do
        n = CardanoWallet.new({protocol: "http", port: 8090}).misc.network.information
        expect(n.code).to eq 200
      end

      it "Can set timeout" do
        n = CardanoWallet.new({timeout: 120, port: 8090}).misc.network.information
        expect(n.code).to eq 200
      end

      it "Can set certs to fly with Daedalus" do
        options = { protocol: "https",
                    host: "localhost",
                    port: "4673",
                    timeout: 120,
                    cacert: "#{Dir.pwd}/spec/certs/ca.crt",
                    pem: "#{Dir.pwd}/spec/certs/client.pem"
                  }
        n = CardanoWallet.new(options)
        expect(n.opt).to eq(options)

      end

      it "ArgumentError when opt is not Hash" do
        expect{ CardanoWallet.new(true) }.to raise_error ArgumentError, "argument should be Hash"
      end

      it "ArgumentError when wrong number of arguments" do
        expect{ CardanoWallet.new({}, "") }.to raise_error ArgumentError, "wrong number of arguments (given 2, expected 0..1)"
      end
  end
end
