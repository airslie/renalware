module Renalware
  module HD
    module Sessions
      describe SaveSession, type: :command do
        include ActiveJob::TestHelper

        let(:patient)       { build_stubbed(:hd_patient) }
        let(:user)          { build_stubbed(:user) }

        def test_listener
          Class.new do
            # We add a saved_session attribute to the class so we can store the
            # session that was passed in the callback
            attr_reader :saved_session, :success

            def save_success(session)
              @saved_session = session
              @success = true
            end

            def save_failure(session)
              @saved_session = session
              @success = false
            end
          end
        end

        describe "Simple creation of session without signoff" do
          let(:patient)       { create(:hd_patient) }
          let(:user)          { create(:user) }
          let(:hospital_unit) { create(:hospital_unit) }

          it "creates a session when args are valid" do
            pgd = create(:patient_group_direction, name: "PGD name1", code: "PCG code1")
            obj = described_class.new(patient: patient, current_user: user)
            params = {
              type: "Renalware::HD::Session::Open",
              hospital_unit: hospital_unit,
              signed_on_by: user,
              patient_group_direction_ids: ["", pgd.id.to_s],
              duration_form: {
                start_date: Time.zone.today,
                start_time: Time.zone.now
              }
            }
            listener = test_listener.new
            obj.subscribe listener
            obj.call(params: params, signing_off: false, id: nil)

            session = listener.saved_session
            expect(session).to be_persisted
            expect(session.patient_group_directions).to eq([pgd])
          end
        end

        it "expects session params to contain type" do
          obj = described_class.new(patient: patient, current_user: user)
          expect { obj.call(params: {}, signing_off: false, id: nil) }.to raise_error(ArgumentError)
        end

        it "broadcasts an event on success" do
          obj = described_class.new(patient: patient, current_user: user)

          expect_any_instance_of(HD::Session).to receive(:save).and_return(true)
          expect {
            obj.call(params: { type: "Renalware::HD::Session::Open" })
          }.to broadcast(:save_success)
        end

        it "broadcasts an event on failure" do
          obj = described_class.new(patient: patient, current_user: user)

          expect_any_instance_of(HD::Session).to receive(:save).and_return(false)
          expect {
            obj.call(params: { type: "Renalware::HD::Session::Open" })
          }.to broadcast(:save_failure)
        end

        it "doesn't enqueue a request to update rolling session stats if its an open session" do
          obj = described_class.new(patient: patient, current_user: user)

          expect_any_instance_of(HD::Session).to receive(:save).and_return(true)

          expect do
            obj.call(params: { type: "Renalware::HD::Session::Open" })
          end.not_to have_enqueued_job
        end

        it "enqueues a request to update rolling session stats if its an closed session" do
          obj = described_class.new(patient: patient, current_user: user)

          expect_any_instance_of(HD::Session).to receive(:save).and_return(true)

          expect do
            obj.call(params: { type: "Renalware::HD::Session::Closed" })
          end.to have_enqueued_job(Renalware::HD::UpdateRollingPatientStatisticsJob)
        end

        it "enqueues a request to update rolling session stats if its an dna session" do
          obj = described_class.new(patient: patient, current_user: user)

          expect_any_instance_of(HD::Session).to receive(:save).and_return(true)

          expect do
            obj.call(params: { type: "Renalware::HD::Session::DNA" })
          end.to have_enqueued_job(Renalware::HD::UpdateRollingPatientStatisticsJob)
        end

        it "assigns the most recent hd dry weight to the session" do
          patient = create(:hd_patient)
          create(:dry_weight, patient_id: patient.id, weight: 100.0, assessed_on: 1.year.ago)
          latest_dw = create(
            :dry_weight,
            patient_id: patient.id,
            weight: 103.0,
            assessed_on: 1.day.ago
          )
          create(:dry_weight, patient_id: patient.id, weight: 99.0, assessed_on: 2.days.ago)

          # Build session params but make sure there is no dry_weight_id in there
          # as this is not usually in the params passed to SaveSession, which will lookup the latest
          # dry_weight itself. Passing it here ends up overwriting the looked-up weight.
          session_attributes = build(
            :hd_closed_session,
            hospital_unit_id: create(:hospital_unit).id
          ).attributes
          session_attributes.delete("dry_weight_id")

          obj = described_class.new(patient: patient, current_user: user)

          # Create a listener to receive broadcast success or failure from SaveSession
          listener = test_listener.new
          obj.subscribe listener

          # Do the save
          obj.call(
            params: session_attributes.update(
              type: "Renalware::HD::Session::Open",
              duration_form: {
                start_date: "2021-01-02",
                start_time: "11:00",
                end_time: "13:00"
              }
            ),
            signing_off: true
          )

          expect(listener.saved_session.errors).to be_blank
          expect(listener.success).to be(true)
          expect(listener.saved_session).to be_valid
          expect(listener.saved_session.dry_weight).to eq(latest_dw)
        end
      end
    end
  end
end
