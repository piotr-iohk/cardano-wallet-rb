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

  describe CardanoWallet::Misc::Proxy do
    it "I could send a transaction" do
      binary_blob = "82839f8200d81858248258201d4ca4d72a1e02fbb79bec42392d9eb3da179f8a2316fd9e9a5ffe9c441d8bce01ff9f8282d818582883581c9c19ec69f7d3acad269e4bbbfcad67129c268bd772060b426b7e23cba102451a4170cb17001a1c281652018282d818582883581c95eaa323cac6cd8916a02c58b133d9b576ceb7bcb1f8c0716a701118a102451a4170cb17001a5e6fce581a0096048effa0818200d8185885825840b8cdd384ec1ef3dffe4db999d6bfce40afaa964543e2e1592c932f552fe9e8301233bbc1f45472837b904b719db5d32d947ec521e7fccd1aec6ad6cf884fc45858403964714f761d79a67b34c8e1fcc337af6ef44a894e6e740927dbec86d1be63e9987dc9ceb7905a53a0ddddf3a9ea4508e41a02d18ed3994461eb20cb0ba2710b"
      PROXY = CardanoWallet.new.misc.proxy
      res = PROXY.submit_external_transaction(binary_blob)
      expect(res.code).to eq 400
    end
  end

end
