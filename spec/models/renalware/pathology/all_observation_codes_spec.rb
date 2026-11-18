module Renalware::Pathology
  describe AllObservationCodes do
    let(:cache) { ActiveSupport::Cache::MemoryStore.new }

    before do
      allow(Rails).to receive(:cache).and_return(cache)
    end

    it "returns codes in database order as uppercase symbols" do
      ObservationDescription.create!(code: "ure")
      ObservationDescription.create!(code: "cre")

      expect(described_class.instance.all).to eq(%i(CRE URE))
    end

    it "reuses the cached list without querying again" do
      ObservationDescription.create!(code: "URE")
      allow(ObservationDescription).to receive(:order).and_call_original

      2.times { expect(described_class.instance.all).to eq([:URE]) }

      expect(ObservationDescription).to have_received(:order).with(:code).once
    end

    it "serves repeat lookups from memory without reading the shared cache" do
      ObservationDescription.create!(code: "URE")
      allow(cache).to receive(:fetch).and_call_original

      3.times { expect(described_class.include?(:URE)).to be(true) }

      expect(cache).to have_received(:fetch).once
    end

    it "picks up shared cache changes once the in-process copy expires" do
      expect(described_class.instance.all).to eq([])
      cache.write(described_class::CACHE_KEY, [:URE])

      expect(described_class.instance.all).to eq([])
      travel described_class::LOCAL_TTL + 1.second do
        expect(described_class.instance.all).to eq([:URE])
      end
    end

    it "refreshes after one hour even if callbacks were bypassed" do
      description = ObservationDescription.create!(code: "URE")
      expect(described_class.instance.all).to eq([:URE])
      description.update_column(:code, "P_URE")

      expect(described_class.instance.all).to eq([:URE])
      travel 1.hour + 1.second do
        expect(described_class.instance.all).to eq([:P_URE])
      end
    end

    describe ".include?" do
      it "preserves symbol membership semantics" do
        ObservationDescription.create!(code: "URE")

        expect(described_class.include?(:URE)).to be(true)
        expect(described_class.include?(:UNKNOWN)).to be(false)
        expect(described_class.include?("URE")).to be(false)
      end
    end

    describe ".invalidate" do
      it "removes only the observation codes cache entry" do
        described_class.instance.all
        cache.write("unrelated", "value")

        described_class.invalidate

        expect(cache.exist?(described_class::CACHE_KEY)).to be(false)
        expect(cache.read("unrelated")).to eq("value")
      end

      it "discards the in-process copy" do
        expect(described_class.instance.all).to eq([])
        ObservationDescription.insert_all([{ code: "URE" }])

        described_class.invalidate

        expect(described_class.instance.all).to eq([:URE])
      end
    end
  end
end
