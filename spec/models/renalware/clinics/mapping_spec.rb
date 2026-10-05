describe Renalware::Clinics::Mapping do
  it { is_expected.to be_versioned }

  it :aggregate_failures do
    is_expected.to validate_presence_of(:name_in_feed)
    is_expected.to belong_to(:clinic).class_name("Renalware::Clinics::Clinic")
  end

  describe "uniqueness" do
    subject {
      described_class.new(name_in_feed: "Clinic A", default_clinic: false, clinic:)
    }

    let(:clinic) { create(:clinic) }

    it { is_expected.to validate_uniqueness_of(:name_in_feed).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:default_clinic).scoped_to(:default_clinic) }
  end
end
