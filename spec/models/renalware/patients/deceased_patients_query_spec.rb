# frozen_string_literal: true

module Renalware
  describe Patients::DeceasedPatientsQuery do
    include PatientsSpecHelper

    subject(:query) { described_class.new(query_params) }

    let(:query_params) { {} }

    describe "#call" do
      subject { query.call }

      context "when there are no deceased patients" do
        it { is_expected.to eq [] }
      end

      context "when there is a patient with a died_on date" do
        it "returns that patient" do
          patient = create(:patient, died_on: "2007-01-01")

          expect(query.call).to eq([patient])
        end
      end

      context "when there is a patient with the death modality" do
        it "returns that patient" do
          patient = create(:patient, died_on: nil)
          set_modality(
            patient: patient,
            modality_description: create(:death_modality_description)
          )

          expect(query.call).to eq([patient])
        end
      end
    end
  end
end
