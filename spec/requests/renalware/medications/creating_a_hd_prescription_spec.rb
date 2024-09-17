# frozen_string_literal: true

describe "Create an HD prescription" do
  let(:patient) { create(:hd_patient, family_name: "Rabbit", local_patient_id: "KCH12345") }
  let(:prescribed_on) { "2024-11-01" }
  let(:prescribed_on_next) { "2024-11-02" }
  let(:prescribed_on_date) { Date.parse(prescribed_on) }
  let(:prescribed_on_next_date) { Date.parse(prescribed_on_next) }

  def prescription_params(administer_on_hd:, stat: false)
    {
      drug_id: create(:drug).id,
      treatable_id: patient.id,
      treatable_type: "Renalware::Patient",
      dose_amount: "10",
      medication_route_id: create(:medication_route).id,
      prescribed_on: prescribed_on,
      provider: "gp",
      unit_of_measure_id: create(:drug_unit_of_measure).id,
      frequency: :once_only,
      administer_on_hd: administer_on_hd,
      stat: stat
    }
  end

  describe "PUT update" do
    context "when prescription is administer_on_hd and not stat" do
      context "when termination date has never been amended manually by the user" do
        it "updates the termination date to be the future date of start_date + configured period" do
          period = 3.months
          initial_prescribed_on = Date.parse(prescribed_on)
          initial_terminated_on = initial_prescribed_on + 3.months

          # Build initial prescription to update. Attach a termination and make sure
          # terminated_on_set_by_user is false, simulating a user creating the prescrip but not
          # specifying a termination date. If they had, terminated_on_set_by_user would be true.
          params = prescription_params(administer_on_hd: true)
          prescription = build(:prescription, params.merge(patient_id: patient.id))
          prescription.termination = build(
            :prescription_termination,
            terminated_on: initial_terminated_on,
            terminated_on_set_by_user: false
          )
          prescription.save!

          allow(Renalware.config)
            .to receive(:auto_terminate_hd_prescriptions_after_period)
            .and_return(period)

          # Simulate editing the prescription and bumping the prescribed_on date on a bit
          new_prescribed_on = initial_prescribed_on + 1.month
          params.update(prescribed_on: new_prescribed_on)

          # Do the update
          put(
            patient_prescription_path(patient, prescription),
            params: { medications_prescription: params }
          )
          follow_redirect!

          expect(response).to be_successful

          prescription = Renalware::Medications::Prescription.last
          expect(prescription).to have_attributes(
            prescribed_on: new_prescribed_on,
            administer_on_hd: true
          )
          expect(prescription.termination).to have_attributes(
            terminated_on: new_prescribed_on + period,
            notes: "HD prescription scheduled to terminate #{period.in_days.to_i} days from start"
          )
        end
      end

      context "when termination date was changed at some point by the user" do
        it "does not change termination date when updated" do
          initial_prescribed_on = Date.parse(prescribed_on)
          initial_terminated_on = initial_prescribed_on + 3.months

          # Build initial prescription to update. Attach a termination and make sure
          # terminated_on_set_by_user is true, simulating a user creating the prescrip and
          # specifying a termination date.
          params = prescription_params(administer_on_hd: true)
          prescription = build(:prescription, params.merge(patient_id: patient.id))
          prescription.termination = build(
            :prescription_termination,
            terminated_on: initial_terminated_on,
            terminated_on_set_by_user: true
          )
          prescription.save!

          # Simulate editing the prescription and bumping the prescribed_on date on a bit
          new_prescribed_on = initial_prescribed_on + 1.month
          params.update(prescribed_on: new_prescribed_on)

          # Do the update
          put(
            patient_prescription_path(patient, prescription),
            params: { medications_prescription: params }
          )
          follow_redirect!

          expect(response).to be_successful

          prescription = Renalware::Medications::Prescription.last
          # terminated_on should not have changed
          expect(prescription.termination).to have_attributes(
            terminated_on: initial_terminated_on
          )
        end
      end
    end

    context "when prescription is administer_on_hd and is stat" do
      it "updates the termination date to be the future date of start_date + configured period" do
        period = 2.weeks
        initial_prescribed_on = Date.parse(prescribed_on)
        initial_terminated_on = initial_prescribed_on + period

        allow(Renalware.config)
          .to receive(:auto_terminate_hd_stat_prescriptions_after_period)
          .and_return(period)

        # Build initial prescription to update
        params = prescription_params(administer_on_hd: true, stat: true)
        prescription = build(:prescription, params.merge(patient_id: patient.id))
        prescription.termination = build(
          :prescription_termination,
          terminated_on: initial_terminated_on
        )
        prescription.save!

        # Simulate editing the prescription and bumping the prescribed_on date on a bit
        new_prescribed_on = initial_prescribed_on + 1.month
        params.update(prescribed_on: new_prescribed_on)

        # Do the update
        put(
          patient_prescription_path(patient, prescription),
          params: { medications_prescription: params }
        )
        follow_redirect!

        expect(response).to be_successful

        prescription = Renalware::Medications::Prescription.last
        expect(prescription).to have_attributes(
          prescribed_on: new_prescribed_on,
          administer_on_hd: true,
          stat: true
        )
        expect(prescription.termination).to have_attributes(
          terminated_on: new_prescribed_on + period,
          notes: "HD prescription scheduled to terminate #{period.in_days.to_i} days from start"
        )
      end
    end
  end

  describe "POST create" do
    context "when prescription is administer_on_hd and not stat" do
      context "when no termination date supplied" do
        it "adds a termination with a future date of start_date + configured period" do
          period = 3.months
          allow(Renalware.config)
            .to receive(:auto_terminate_hd_prescriptions_after_period)
            .and_return(period)

          params = prescription_params(administer_on_hd: true)
          post(
            patient_prescriptions_path(patient),
            params: { medications_prescription: params }
          )
          follow_redirect!

          expect(response).to be_successful

          prescription = Renalware::Medications::Prescription.last
          expect(prescription).to have_attributes(
            prescribed_on: prescribed_on_date,
            administer_on_hd: true
          )
          expect(prescription.termination).to have_attributes(
            terminated_on: prescribed_on_date + period,
            notes: "HD prescription scheduled to terminate #{period.in_days.to_i} days from start"
          )
        end

        it "does not create a termination if the configured period is nil" do
          allow(Renalware.config)
            .to receive(:auto_terminate_hd_prescriptions_after_period)
            .and_return(nil)

          params = prescription_params(administer_on_hd: true)

          post(
            patient_prescriptions_path(patient),
            params: { medications_prescription: params }
          )
          follow_redirect!
          expect(response).to be_successful

          expect(Renalware::Medications::Prescription.last.termination).to be_nil
        end

        it "does not error when data is missing" do
          period = 3.months
          allow(Renalware.config)
            .to receive(:auto_terminate_hd_prescriptions_after_period)
            .and_return(period)

          # Pass an invalid prescribed_on
          params = prescription_params(administer_on_hd: true).update(prescribed_on: "")

          expect {
            post(
              patient_prescriptions_path(patient),
              params: { medications_prescription: params }
            )
          }.not_to change(Renalware::Medications::Prescription, :count)

          expect(response).to be_successful # validation error, mno redirect
        end
      end

      context "when a termination date is supplied" do
        it "does not override it, and sets terminated_on_edited=true" do
          period = 3.months
          allow(Renalware.config)
            .to receive(:auto_terminate_hd_prescriptions_after_period)
            .and_return(period)

          params = prescription_params(administer_on_hd: true)
          params[:termination_attributes] = { terminated_on: prescribed_on_next }
          post(
            patient_prescriptions_path(patient),
            params: { medications_prescription: params }
          )
          follow_redirect!

          expect(response).to be_successful

          prescription = Renalware::Medications::Prescription.last
          # unchanged terminated_on
          expect(prescription.termination).to have_attributes(
            terminated_on: prescribed_on_next_date,
            terminated_on_set_by_user: true
          )
        end
      end
    end

    context "when prescription is administer_on_hd and stat (give once)" do
      it "additionally saves a termination with a future date of start_date + configured period" do
        period = 2.weeks
        allow(Renalware.config)
          .to receive(:auto_terminate_hd_stat_prescriptions_after_period)
          .and_return(period)

        params = prescription_params(administer_on_hd: true, stat: true)
        post(
          patient_prescriptions_path(patient),
          params: { medications_prescription: params }
        )
        follow_redirect!

        expect(response).to be_successful

        prescription = Renalware::Medications::Prescription.last
        expect(prescription).to have_attributes(
          prescribed_on: prescribed_on_date,
          administer_on_hd: true
        )
        expect(prescription.termination).to have_attributes(
          terminated_on: prescribed_on_date + period,
          notes: "HD prescription scheduled to terminate #{period.in_days.to_i} days from start"
        )
      end

      it "does not create a termination if the configured period is nil" do
        allow(Renalware.config)
          .to receive(:auto_terminate_hd_stat_prescriptions_after_period)
          .and_return(nil)

        params = prescription_params(administer_on_hd: true, stat: true)

        post(
          patient_prescriptions_path(patient),
          params: { medications_prescription: params }
        )
        follow_redirect!
        expect(response).to be_successful

        expect(Renalware::Medications::Prescription.last.termination).to be_nil
      end
    end

    context "when administer_on_hd is false" do
      it "does not create a termination" do
        allow(Renalware.config)
          .to receive(:auto_terminate_hd_prescriptions_after_period)
          .and_return(6.months)

        params = prescription_params(administer_on_hd: false)
        post(
          patient_prescriptions_path(patient),
          params: { medications_prescription: params }
        )
        follow_redirect!

        expect(response).to be_successful

        prescription = Renalware::Medications::Prescription.last
        expect(prescription).to have_attributes(administer_on_hd: false, termination: nil)
      end
    end
  end
end
