# frozen_string_literal: true

module Renalware
  module HD
    describe Session do
      it_behaves_like "an Accountable model"
      it_behaves_like "a Paranoid model"
      it :aggregate_failures do
        is_expected.to be_versioned
        is_expected.to have_many(:prescription_administrations)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to belong_to(:dialysate)
        is_expected.to belong_to(:station)
        is_expected.to have_many(:patient_group_directions)
        is_expected.to have_many(:session_patient_group_directions)
      end

      describe "patient_group_directions validation" do
        context "when Renalware.config.hd_session_require_patient_group_directions is true" do
          before do
            allow(Renalware.config)
              .to receive(:hd_session_require_patient_group_directions)
              .and_return(true)
          end

          it { is_expected.to validate_presence_of(:patient_group_directions) }
        end

        context "when Renalware.config.hd_session_require_patient_group_directions is false" do
          before do
            allow(Renalware.config)
              .to receive(:hd_session_require_patient_group_directions)
              .and_return(false)
          end

          it { is_expected.not_to validate_presence_of(:patient_group_directions) }
        end
      end
    end
  end
end
