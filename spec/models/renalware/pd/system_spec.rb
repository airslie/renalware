module Renalware
  describe PD::System do
    it_behaves_like "a Paranoid model"

    it :aggregate_failures do
      is_expected.to validate_presence_of :name
      is_expected.to validate_presence_of :pd_type
    end

    describe "#for_apd" do
      it "only returns apd systems" do
        create(:capd_system)
        apd_system = create(:apd_system)
        expect(described_class.for_apd).to eq [apd_system]
      end
    end

    describe "#for_capd" do
      it "only returns capd systems" do
        capd_system = create(:capd_system)
        create(:apd_system)
        expect(described_class.for_capd).to eq [capd_system]
      end
    end
  end
end
