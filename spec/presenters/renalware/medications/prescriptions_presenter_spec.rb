# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Medications
    describe PrescriptionPresenter do
      describe "#to_s" do
        it "returns a string as close as possible to NHS guidelines" do
          drug = instance_double(Drugs::Drug, name: "Drug X", to_s: "Drug X")
          prescription = instance_double(
            Prescription,
            drug: drug,
            dose_amount: "10",
            dose_unit: "milligram",
            medication_route: instance_double(MedicationRoute, code: "PO", other?: false),
            frequency: "nocte"
          )
          presenter = described_class.new(prescription)

          expect(presenter.to_s).to eq("Drug X - DOSE 10 mg - PO - nocte")
        end
      end

      describe "#provider_suffix" do
        # rubocop:disable Lint/DuplicateHashKey
        map = {
          hospital: "HOSP",
          home_delivery: "HOSP",
          gp: "GP",
          "rubbish": nil,
          "gp": "GP"
        }
        # rubocop:enable Lint/DuplicateHashKey

        map.each do |provider, suffix|
          it "return #{suffix} when provider is #{provider}" do
            prescription = instance_double(Prescription, provider: provider)

            expect(described_class.new(prescription).provider_suffix).to eq(suffix)
          end
        end
      end
    end
  end
end
