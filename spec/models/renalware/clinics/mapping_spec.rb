module Renalware::Clinics
  describe Mapping do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:name_in_feed)
      is_expected.to belong_to(:clinic).class_name("Renalware::Clinics::Clinic")
    end

    describe "uniqueness" do
      subject {
        described_class.new(name_in_feed: "Clinic A", default_clinic: false, clinic:)
      }

      let(:clinic) { create(:clinic) }

      it { is_expected.to validate_uniqueness_of(:name_in_feed) }
      it { is_expected.to validate_uniqueness_of(:default_clinic).scoped_to(:default_clinic) }
    end

    describe ".clinic_for" do
      let(:clinic1) { create(:clinic) }
      let(:clinic2) { create(:clinic) }
      let(:clinic3) { create(:clinic) }

      before do
        described_class.create!(name_in_feed: "Clinic A", clinic: clinic1, default_clinic: false)
        described_class.create!(name_in_feed: "Clinic B", clinic: clinic2, default_clinic: false)
        described_class.create!(
          name_in_feed: "Default Clinic", clinic: clinic3, default_clinic: true
        )
      end

      it "returns the clinic_id for a matching name" do
        expect(described_class.clinic_for("Clinic A")).to eq(clinic1)
        expect(described_class.clinic_for("Clinic B")).to eq(clinic2)
      end

      it "returns the default clinic_id if no name match" do
        expect(described_class.clinic_for("Non-existent Clinic")).to eq(clinic3)
      end

      it "returns the nil if clinic name is nil" do
        expect(described_class.clinic_for(nil)).to be_nil
      end

      it "returns nil if no match and no default clinic" do
        described_class.where(default_clinic: true).delete_all
        expect(described_class.clinic_for("Non-existent Clinic")).to be_nil
      end
    end
  end
end
