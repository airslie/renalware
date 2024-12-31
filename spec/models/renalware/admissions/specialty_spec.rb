describe Renalware::Admissions::Specialty do
  it { is_expected.to validate_presence_of :name }

  describe "uniqueness" do
    subject { described_class.new(name: "Other") }

    it { is_expected.to validate_uniqueness_of :name }
  end
end
