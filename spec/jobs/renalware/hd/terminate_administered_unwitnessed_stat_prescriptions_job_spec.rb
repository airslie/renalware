module Renalware
  module HD
    describe TerminateAdministeredUnwitnessedStatPrescriptionsJob do
      let(:pwd) { "password" }
      let(:user1) { create(:user, password: pwd) }
      let(:user2) { create(:user, password: pwd) }
      let(:prescription) { create(:prescription, administer_on_hd: true, stat: true) }

      before { create(:user, :system) }

      describe "#perform" do
        def prescription_administration(witnessed:, administered:, stat:)
          prescription = create(:prescription, administer_on_hd: true, stat: stat)
          pa = PrescriptionAdministration.new(
            prescription: prescription,
            administered: administered,
            administered_by: user1,
            administered_by_password: pwd,
            recorded_on: Time.zone.now,
            by: user1
          )
          if witnessed
            pa.witnessed_by = user2
            pa.witnessed_by_password = pwd
          else
            pa.skip_witness_validation = true
          end
          pa.save!

          expect(prescription.reload.termination.present?).to eq(witnessed)
          pa
        end

        it "terminates administered HD stat prescriptions that are sitting around unwitnessed" do
          # This is because stat prescriptions should only be given once - so if any have been given
          # but not signed off, then we want periodically terminate these.
          witnessed_administered_stat_pa = prescription_administration(
            witnessed: true,
            administered: true,
            stat: true
          ) # prescription already terminated
          unwitnessed_administered_stat_pa = prescription_administration(
            witnessed: false,
            administered: true,
            stat: true
          )
          unwitnessed_unadministered_stat_pa = prescription_administration(
            witnessed: false,
            administered: false,
            stat: true
          )
          unwitnessed_administered_nonstat_pa = prescription_administration(
            witnessed: false,
            administered: true,
            stat: false # should not terminate as not stat
          )

          # sanity checks!
          expect(witnessed_administered_stat_pa.prescription.termination).to be_present
          expect(unwitnessed_administered_stat_pa.prescription.termination).to be_nil
          expect(unwitnessed_unadministered_stat_pa.prescription.termination).to be_nil
          expect(unwitnessed_administered_nonstat_pa.prescription.termination).to be_nil

          # When we run the job, it should only terminate prescriptions for
          # hd prescription administrations where
          # - it is administered
          # - the prescription is not already terminated (caused by witnessing at some point)
          # - the prescription is marked as give on hd and is stat (give once only)

          # So.. we are going to terminate the prescriptions for
          #  unwitnessed_administered_stat_pa
          # only!

          described_class.perform_now

          expect(unwitnessed_administered_stat_pa.prescription.reload.termination).to be_present

          # Sanity checks that these have not changed
          expect(witnessed_administered_stat_pa.prescription.reload.termination).to be_present
          expect(unwitnessed_unadministered_stat_pa.prescription.reload.termination).to be_nil
          expect(unwitnessed_administered_nonstat_pa.prescription.reload.termination).to be_nil
        end
      end
    end
  end
end
