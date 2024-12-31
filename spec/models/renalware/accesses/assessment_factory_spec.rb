module Renalware
  module Accesses
    describe AssessmentFactory do
      subject(:assessment) { described_class.new(patient: patient).build }

      let(:patient) { create(:accesses_patient) }

      describe "#build" do
        it "applies default to the assessment" do
          travel_to Time.zone.parse("2004-11-24 01:04:44")

          expect(assessment.performed_on.to_s).to eq("2004-11-24")
        end

        context "with a current access profile" do
          let!(:profile) { create(:access_profile, :current, patient: patient) }

          it "applies the access details from the current access" do
            expect(assessment).to have_attributes(
              type: profile.type,
              side: profile.side
            )
          end
        end
      end
    end
  end
end
