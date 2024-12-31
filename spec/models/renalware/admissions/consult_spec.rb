describe Renalware::Admissions::Consult do
  it_behaves_like "an Accountable model"
  it :aggregate_failures do
    is_expected.to validate_presence_of :patient_id
    is_expected.to validate_presence_of :started_on
    is_expected.to validate_presence_of :description
    is_expected.to validate_numericality_of :priority
    is_expected.to belong_to(:patient).touch(true)
    is_expected.to belong_to(:consult_site)
    is_expected.to belong_to(:hospital_ward)
    is_expected.to belong_to(:specialty)
    is_expected.to respond_to(:rrt)
  end

  describe "validation" do
    context "when consult_site_id and hospital_ward_id are not present" do
      subject { described_class.new(consult_site_id: nil, hospital_ward_id: nil) }

      it { is_expected.to validate_presence_of :other_site_or_ward }
    end

    context "when consult_site_id is present and hospital_ward_id is not" do
      subject { described_class.new(consult_site_id: 1, hospital_ward_id: nil) }

      it { is_expected.not_to validate_presence_of :other_site_or_ward }
    end

    context "when consult_site_id is not present and hospital_ward_id is" do
      subject { described_class.new(consult_site_id: nil, hospital_ward_id: 1) }

      it { is_expected.not_to validate_presence_of :other_site_or_ward }
    end
  end
end
