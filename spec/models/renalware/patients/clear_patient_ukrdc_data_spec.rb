# frozen_string_literal: true

module Renalware
  module Patients
    describe ClearPatientUKRDCData do
      describe "#call" do
        it "clears the PKB (previously RPV) status if the modality description type is death" do
          freeze_time do
            patient = create(:patient, send_to_rpv: true, rpv_decision_on: 1.year.ago)
            user = create(:user)

            described_class.call(patient: patient, by: user)

            patient.reload
            expect(patient.send_to_rpv).to be(false)
            expect(patient.rpv_decision_on).to eq(Time.zone.today)
            expect(patient.rpv_recorded_by).to eq(user.to_s)
          end
        end

        context "when the patient has data that would cause a validation error" do
          it "saves anyway, skipping validations, because a bad email address for example " \
             "should not prevent this action" do
            user = create(:user)
            patient = build(:patient, send_to_rpv: true, email: "invalid-email-address", by: user)

            # Check this would normally result in a validation error
            expect { patient.save! }.to raise_error(ActiveRecord::RecordInvalid)

            # Now save without validation so we have an invalid persisted record to deal with
            patient.save!(validate: false)

            # calling the service object should not raise an error!
            expect {
              described_class.call(patient: patient, by: user)
            }.not_to raise_error

            patient.reload
            expect(patient.send_to_rpv).to be(false)
            expect(patient.rpv_decision_on).to eq(Time.zone.today)
            expect(patient.rpv_recorded_by).to eq(user.to_s)
          end
        end
      end
    end
  end
end
