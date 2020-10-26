# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe "renalware/letters/parts/_clinical_observations", type: :view do
    helper(Renalware::LettersHelper)
    helper(Renalware::AttributeNameHelper)

    subject { render partial: partial, locals: { clinical_observations: part } }

    let(:partial) { "renalware/letters/parts/clinical_observations" }
    let(:part) { Letters::Part::ClinicalObservations.new(nil, nil, clinic_visit) }
    let(:clinic_visit) {
      Clinics::ClinicVisit.new(
        height: 1.8,
        weight: 90.0,
        bmi: 27.8,
        bp: "110/70",
        urine_blood: :low,
        urine_protein: :trace
      )
    }

    it "renders the visit observations", :aggregate_failures do
      is_expected.to include("BMI")
      is_expected.to include("27.8")
      is_expected.to include("Height")
      is_expected.to include("1.8 m")
      is_expected.to include("Weight")
      is_expected.to include("90.0 kg")
      is_expected.to include("BP")
      is_expected.to include("110/70")
      is_expected.to include("Urine Blood")
      is_expected.to include("+")
      is_expected.to include("Urine Protein")
      is_expected.to include("Trace")
    end

    context "when some observations are missing" do
      let(:clinic_visit) {
        Clinics::ClinicVisit.new(
          height: 1.81,
          urine_protein: :trace
        )
      }

      it "does not render them at all", :aggregate_failures do
        is_expected.to include("Height")
        is_expected.to include("1.81 m")
        is_expected.not_to include("Weight")
        is_expected.not_to include("BMI") # can't calculate with weight so will be omitted
        is_expected.not_to include("BP")
        is_expected.not_to include("110/70")
        is_expected.not_to include("Urine blood")
        is_expected.to include("Urine Protein")
        is_expected.to include("Trace")
      end
    end
  end
end
