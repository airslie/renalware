# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Feeds::PatientLocator do
    describe ".strategy" do
      context "when strategy is configured as :dob_and_any_nhs_or_assigning_auth_number" do
        before do
          Renalware.configure do |config|
            config.hl7_patient_locator_strategy = :dob_and_any_nhs_or_assigning_auth_number
          end
        end

        it "returns the correct strategy class" do
          expect(described_class.strategy)
            .to eq(Renalware::Feeds::PatientLocatorStrategies::DobAndAnyNHSOrAssigningAuthNumber)
        end
      end

      context "when strategy is configured as :simple" do
        before do
          Renalware.configure do |config|
            config.hl7_patient_locator_strategy = :simple
          end
        end

        it "returns the correct strategy class" do
          expect(described_class.strategy)
            .to eq(Renalware::Feeds::PatientLocatorStrategies::Simple)
        end
      end
    end
  end
end
