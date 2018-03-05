# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Events
    describe Investigation, type: :model do
      describe "#document" do
        subject { described_class.new.document }

        it { is_expected.to validate_presence_of(:modality) }
        it { is_expected.to validate_presence_of(:type) }
        it { is_expected.to validate_presence_of(:result) }
      end

      describe "scopes" do
        let(:patient) { create(:patient) }
        let!(:donor_investig) { create(:investigation, :transplant_donor, patient: patient) }
        let!(:recip_investig) { create(:investigation, :transplant_recipient, patient: patient) }

        describe ".transplant_donors" do
          context "when there are 2 Investigations for the patient but only one is as a donor" do
            subject { described_class.transplant_donors }

            it { is_expected.to eq([donor_investig]) }
          end
        end

        describe ".transplant_recipients" do
          context "when there are 2 Investigations for the patient but only one is as a donor" do
            subject { described_class.transplant_recipients }

            it { is_expected.to eq([recip_investig]) }
          end
        end
      end
    end
  end
end
