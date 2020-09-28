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
      expect(NETWORK.parameters.code).to eq 200
    end
  end

  describe CardanoWallet::Misc::Utils do
    before(:all) do
        UTILS = CardanoWallet.new.misc.utils
    end

    it "Inspect invalid address" do
      addr = "addr"
      res = UTILS.addresses addr
      expect(res).to include "bad_request"
      expect(res.code).to eq 400
    end

    it "Inspect Shelley payment address" do
      addr = "addr1qqlgm2dh3vpv07cjfcyuu6vhaqhf8998qcx6s8ucpkly6f8l0dw5r75vk42mv3ykq8vyjeaanvpytg79xqzymqy5acmqej0mk7"
      res = UTILS.addresses addr
      expect(res['address_style']).to eq "Shelley"
      expect(res['stake_reference']).to eq "by value"
      expect(res['stake_key_hash']).to eq "ff7b5d41fa8cb555b6449601d84967bd9b0245a3c530044d8094ee36"
      expect(res['spending_key_hash']).to eq "3e8da9b78b02c7fb124e09ce6997e82e9394a7060da81f980dbe4d24"
      expect(res['network_tag']).to eq 0
      expect(res.code).to eq 200
    end

    it "Inspect Shelley stake address" do
      addr = "stake_test1uzws33ghf8kugc8ea8p7h8mr7dcsl6ggw7tfy479y9t0d4qp48dkq"
      res = UTILS.addresses addr
      expect(res['address_style']).to eq "Shelley"
      expect(res['stake_reference']).to eq "by value"
      expect(res['stake_key_hash']).to eq "9d08c51749edc460f9e9c3eb9f63f3710fe90877969257c52156f6d4"
      expect(res['network_tag']).to eq 0
      expect(res.code).to eq 200
    end

    it "Inspect Byron Random address" do
      addr = "37btjrVyb4KEzz6YprjHfqz3DS4JvoDpAf3QWLABzQ7uzMEk7g3PD2AwL1SbYWekneuRFkyTipbyKMZyEMed5LroZtQAvA2LqcWmJuwaqt6oJLbssS"
      res = UTILS.addresses addr
      expect(res['address_style']).to eq "Byron"
      expect(res['stake_reference']).to eq "none"
      expect(res['address_root']).to eq "c23a0f86c7bc977f0dee4721c9850467047a0e6acd928a991b5cbba8"
      expect(res['derivation_path']).to eq "581c6a6589ca57730b33d1bb316c13a76d7794a11ba2d077724bdfb51b45"
      expect(res['network_tag']).to eq 1097911063
      expect(res.code).to eq 200
    end

    it "Inspect Byron Icarus address" do
      addr = "2cWKMJemoBajQcoTotf4xYba7fV7Ztx7AvbnzvaQY6PbezPWM6DtJD6Df2bVejBCpykmt"
      res = UTILS.addresses addr
      expect(res['address_style']).to eq "Icarus"
      expect(res['stake_reference']).to eq "none"
      expect(res['address_root']).to eq "88940c753ee50d556ecaefadd0d2fee9fabacf4366a7d4a8cdfa2b64"
      expect(res['network_tag']).to eq 1097911063
      expect(res.code).to eq 200
    end

  end

end
