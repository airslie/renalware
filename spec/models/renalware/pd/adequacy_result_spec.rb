# frozen_string_literal: true

module Renalware
  module PD
    describe AdequacyResult do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to validate_presence_of(:performed_on)
        is_expected.to validate_numericality_of(:height)
        is_expected.to validate_numericality_of(:weight)
      end

      describe "derivation of calculated attributes before saving" do
        let(:patient) { create(:pd_patient, sex: "M", born_on: "1967-01-01") }

        context "when there is no recent weight" do
          it "does not update the calculated columns" do
            result = create(:pd_adequacy_result, patient: patient, weight: nil)

            expect(result.dietry_protein_intake).to be_nil
          end
        end

        context "when weight is missing" do
          it "does not update the calculated columns" do
            result = create(:pd_adequacy_result, patient: patient, weight: nil)

            expect(result.dietry_protein_intake).to be_nil
          end
        end

        context "when there is a weight" do
          it "updates the calculated columns" do
            result = create(:pd_adequacy_result, patient: patient, weight: 100)

            expect(result.dietry_protein_intake).to be > 0
          end
        end
      end

      describe "#complete" do
        let(:patient) { create(:pd_patient) }

        context "when all calculated creatinine clearance and kt/v values are present" do
          it "is is complete" do
            # before_save callback will set the complete? boolean
            # Note that as there is no height weight, the derive_calculated_attributes callback
            # exits early - otherwise it would calculate the attributes we are
            # setting below and override them.
            result = create(
              :pd_adequacy_result,
              patient: patient,
              total_creatinine_clearance: 1,
              pertitoneal_creatinine_clearance: 1,
              renal_creatinine_clearance: 1,
              total_ktv: 1,
              pertitoneal_ktv: 1,
              renal_ktv: 1,
              weight: 100.23,
              height: 1.99
            )

            expect(result).to be_complete
          end
        end

        context "when uring 24 is missing so that renal (but not peritoneal) calcs can't be done" do
          it "is complete" do
            result = create(
              :pd_adequacy_result,
              patient: patient,
              dial_24_missing: false,
              pertitoneal_creatinine_clearance: 1,
              pertitoneal_ktv: 1,
              urine_24_missing: true,          # !!
              renal_creatinine_clearance: nil, # no urine so cannot be calced
              renal_ktv: nil,                  # no urine so cannot be calced
              total_ktv: nil,                  # no renal_ktv so calc not poss
              total_creatinine_clearance: nil, # no renal_creatinine_clearance so calc not poss
              weight: 100.23,
              height: 1.99
            )

            expect(result).to be_complete
          end
        end

        context "when urine 24 vol == 0 indicating anuric so that renal (but not peritoneal)" do
          it "is complete" do
            result = create(
              :pd_adequacy_result,
              patient: patient,
              dial_24_missing: false,
              pertitoneal_creatinine_clearance: 1,
              pertitoneal_ktv: 1,
              urine_24_missing: false,
              urine_24_vol: 0,                 # !!
              renal_creatinine_clearance: 0, # no urine so cannot be calced
              renal_ktv: 0,                  # no urine so cannot be calced
              total_ktv: 1,                  # no renal_ktv so calc not poss
              total_creatinine_clearance: 1, # no renal_creatinine_clearance so calc not poss
              weight: 100.23,
              height: 1.99
            )

            expect(result).to be_complete
          end
        end

        context "when dial 24 is missing so that peritoneal calcs can't be done" do
          it "is is complete" do
            result = create(
              :pd_adequacy_result,
              patient: patient,
              dial_24_missing: true,                 # !!
              pertitoneal_creatinine_clearance: nil, # no dialysate so cannot be calced
              pertitoneal_ktv: nil,                  # no dialysate so cannot be calced
              urine_24_missing: false,
              renal_creatinine_clearance: 1,
              renal_ktv: 1,
              total_ktv: nil,                  # no pertitoneal_ktv so calc not poss
              total_creatinine_clearance: nil, # no pertitoneal_creatinine_clearance so calc no poss
              weight: 100.23,
              height: 1.99
            )

            expect(result).to be_complete
          end
        end
      end
    end
  end
end
