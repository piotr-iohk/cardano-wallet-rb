RSpec.describe CardanoWallet::Misc do

  describe CardanoWallet::Misc::Network do
    before(:all) do
        NETWORK = CardanoWallet.new.misc.network
    end

    it "Can get network information" do
      expect(NETWORK.information.code).to eq 200
    end

    it "Can check network clock offset" do
      expect(NETWORK.clock.code).to eq 200
    end

    it "Can check network parameters" do
      expect(NETWORK.parameters("latest").code).to eq 200
    end
  end

end
