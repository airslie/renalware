require "rails_helper"
require_dependency "models/renalware/concerns/personable"

module Renalware
  module Letters
    describe Patient, type: :model do
      include LettersSpecHelper

      let(:patient) { create(:letter_patient) }

      describe "#cc_on_letter?" do
        context "letter is for another patient" do
          it "returns false" do
            patient.cc_on_all_letters = true
            letter = build_letter_to(:patient)

            expect(patient.cc_on_letter?(letter)).to be_falsy
          end
        end

        context "letter is sent to patient" do
          let(:letter) { build_letter_to(:patient, patient: patient) }

          it "returns false" do
            expect(patient.cc_on_letter?(letter)).to be_falsy
          end
        end

        context "letter is sent to doctor" do
          let(:letter) { build_letter_to(:doctor, patient: patient) }

          it "returns true if option is set in its profile" do
            patient.cc_on_all_letters = true

            expect(patient.cc_on_letter?(letter)).to be_truthy
          end

          it "returns false if option not set in its profile" do
            patient.cc_on_all_letters = false

            expect(patient.cc_on_letter?(letter)).to be_falsy
          end
        end
      end
    end
  end
end
