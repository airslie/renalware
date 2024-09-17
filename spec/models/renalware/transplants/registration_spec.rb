# frozen_string_literal: true

module Renalware
  module Transplants
    describe Registration do
      let(:registration) { create(:transplant_registration, :with_statuses) }
      let(:earliest_status) { registration.statuses.order("created_at ASC").first }
      let(:latest_status) { registration.statuses.order("created_at DESC").first }
      let(:clinician) { create(:user, :clinical) }
      let(:status_description) { create(:transplant_registration_status_description) }
      let(:status_description1) do
        create(:transplant_registration_status_description, name: "Status1", code: "Status1")
      end
      let(:status_description2) do
        create(:transplant_registration_status_description, name: "Status2", code: "Status2")
      end

      it :aggregate_failures do
        is_expected.to accept_nested_attributes_for(:statuses)
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to be_versioned
      end

      describe "#update_attributes" do
        context "when creating the registration" do
          let(:patient) { create(:patient) }

          it "creates the status at the same time" do
            params = {
              patient_id: patient.id,
              statuses_attributes: {
                "0": {
                  started_on: "03-11-2015",
                  description_id: status_description.id,
                  by: clinician
                }
              }
            }

            registration = described_class.new
            registration.update(params)
            expect(registration).to be_persisted
            expect(registration.statuses.count).to eq(1)
          end
        end
      end

      describe "#current_status" do
        it "returns the status not terminated" do
          expect(registration.current_status).to eq(latest_status)
        end
      end

      describe "#add_status!" do
        it "returns the new status" do
          status = registration.add_status!(by: clinician)
          expect(status).to be_a(RegistrationStatus)
        end

        it "terminates the current status" do
          status = registration.current_status

          registration.add_status!(
            description: status_description,
            started_on: Time.zone.today,
            by: clinician
          )
          expect(status.reload).to be_terminated
        end

        it "returns status with errors if not valid" do
          status = registration.add_status!({})

          expect(status).not_to be_valid
        end

        context "when > 1 status is added on the same day" do
          it "activates only the most recently added status" do
            initial_status = registration.current_status

            new_status_a = registration.add_status!(
              description: status_description,
              started_on: Time.zone.today,
              by: clinician
            )
            new_status_b = registration.add_status!(
              description: status_description1,
              started_on: Time.zone.today,
              by: clinician
            )
            new_status_c = registration.add_status!(
              description: status_description2,
              started_on: Time.zone.today,
              by: clinician
            )
            expect(initial_status.reload).to be_terminated
            expect(new_status_a.reload).to be_terminated
            expect(new_status_b.reload).to be_terminated
            expect(new_status_c.reload).not_to be_terminated
          end
        end
      end

      describe "#update_status!" do
        it "returns the updated status" do
          status = registration.update_status!(earliest_status, by: clinician)

          expect(status).to be_a(RegistrationStatus)
        end

        it "updates the status with given parameters" do
          datestamp = earliest_status.started_on + 1.day

          registration.update_status!(earliest_status, started_on: datestamp, by: clinician)

          expect(earliest_status.reload.started_on).to eq(datestamp)
        end
      end

      describe "#delete_status!" do
        it "updates the status with given parameters" do
          registration.delete_status!(earliest_status)

          expect(registration.statuses.where(id: earliest_status.id)).not_to be_exists
        end

        it "recomputes the termination dates" do
          allow(registration).to receive(:recompute_termination_dates!)

          registration.delete_status!(earliest_status)

          expect(registration).to have_received(:recompute_termination_dates!)
        end
      end
    end
  end
end
