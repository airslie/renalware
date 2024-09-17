# frozen_string_literal: true

describe Renalware::Admissions::Admission do
  include PatientsSpecHelper
  let(:patient) do
    create(:patient).tap do |pat|
      set_modality(
        patient: pat,
        modality_description: create(:hd_modality_description),
        by: user
      )
    end
  end
  let(:user) { create(:user) }
  let(:modality_desc) { create(:hd_modality_description) }

  it :aggregate_failures do
    is_expected.to validate_presence_of :patient_id
    is_expected.to validate_presence_of :hospital_ward_id
    is_expected.to validate_presence_of :admitted_on
    is_expected.to validate_presence_of :reason_for_admission
    is_expected.to validate_presence_of :admission_type
    is_expected.to belong_to(:patient).touch(true)
    is_expected.to belong_to(:hospital_ward)
    is_expected.to belong_to(:modality_at_admission)
  end

  it_behaves_like "an Accountable model"
  it_behaves_like "a Paranoid model"

  describe "scope .currently_admitted" do
    it "returns only currently admitted patients" do
      create(
        :admissions_admission,
        patient: patient,
        discharged_on: "2017-12-12"
      ) # prev. admission
      current_admission = create(
        :admissions_admission,
        patient: patient,
        discharged_on: nil
      )

      expect(described_class.currently_admitted).to eq [current_admission]
    end
  end

  describe "scope .discharged_but_missing_a_summary" do
    it "returns only discharged patients who have no discharge summary yet" do
      create(
        :admissions_admission,
        patient: patient,
        discharged_on: "2017-12-12",
        discharge_summary: "discharge summary"
      )
      disch_without_summ = create(
        :admissions_admission,
        patient: patient,
        discharged_on: "2017-12-12",
        discharge_summary: nil
      )

      expect(described_class.discharged_but_missing_a_summary).to eq [disch_without_summ]
    end
  end
end
