describe Renalware::Medications::ExpiringHDPrescriptionsForConsultantQuery do
  let(:consultant)        { create(:user, :minimal, consultant: true) }
  let(:other_consultant)  { create(:user, :minimal, consultant: true) }
  let(:non_consultant)    { create(:user, :minimal, consultant: false) }
  let(:hd_patient)        { create(:hd_patient, :with_hd_modality) }
  let(:other_hd_patient)  { create(:hd_patient, :with_hd_modality) }
  let(:pd_patient)        { create(:pd_patient, :with_pd_modality) }

  # rubocop:disable Metrics/MethodLength
  def create_prescription(patient:, user:, terminated_on: 1.day.from_now, **)
    create(
      :prescription,
      patient: patient,
      administer_on_hd: true,
      stat: nil,
      prescribed_on: 2.weeks.ago,
      by: user,
      **
    ) do |prescription|
      prescription.build_termination(
        terminated_on: terminated_on,
        terminated_on_set_by_user: false, # important
        notes: "HD prescription scheduled to terminate 182 days from start",
        by: user
      )
      prescription.save!
    end
  end
  # rubocop:enable Metrics/MethodLength

  context "when the user is not a consultant" do
    before { hd_patient.update(named_consultant: non_consultant, by: non_consultant) }

    it "returns an empty array" do
      create_prescription(
        patient: hd_patient,
        user: non_consultant,
        terminated_on: 1.day.from_now
      )

      expect(described_class.call(user: non_consultant)).to eq([])
    end
  end

  context "when the user is a consultant" do
    before { hd_patient.update(named_consultant: consultant, by: consultant) }

    context "when the consultant has named HD patients with soon-to-be-expiring prescriptions" do
      it "returns only prescriptions for the consultant's patients" do
        expect(hd_patient.id).not_to eq(other_hd_patient.id)
        _prescription_for_other_patient_under_other_consultant = create_prescription(
          patient: other_hd_patient,
          user: other_consultant,
          terminated_on: 1.day.from_now
        )
        prescription = create_prescription(
          patient: hd_patient,
          user: consultant,
          terminated_on: 1.day.from_now
        )

        prescriptions = described_class.call(user: consultant)

        expect(prescriptions.length).to eq(1)
        expect(prescriptions).to eq([prescription])
      end

      it "returns only prescriptions for current HD patients" do
        pd_patient.update(named_consultant: consultant, by: consultant)

        _prescription_for_my_pd_patient = create_prescription(
          patient: pd_patient,
          user: consultant,
          terminated_on: 1.day.from_now
        )
        prescription = create_prescription(
          patient: hd_patient,
          user: consultant,
          terminated_on: 1.day.from_now
        )

        prescriptions = described_class.call(user: consultant)

        expect(prescriptions.length).to eq(1)
        expect(prescriptions).to eq([prescription])
      end

      it "ignores stat prescriptions" do
        create_prescription(
          patient: hd_patient,
          user: consultant,
          terminated_on: 1.day.from_now,
          stat: true
        )

        expect(described_class.call(user: consultant)).to eq([])
      end

      it "ignores administer_on_hd = false prescriptions" do
        create_prescription(
          patient: hd_patient,
          user: consultant,
          terminated_on: 1.day.from_now,
          administer_on_hd: false
        )

        expect(described_class.call(user: consultant)).to eq([])
      end

      it "ignores where terminated_on_set_by_user = true" do
        prescription = create_prescription(
          patient: hd_patient,
          user: consultant,
          terminated_on: 1.day.from_now
        )
        prescription.termination.update!(terminated_on_set_by_user: true)

        expect(described_class.call(user: consultant)).to eq([])
      end

      it "ignores where termination.notes do not include the auto-generated string " \
         "'scheduled to terminate'" do
        prescription = create_prescription(
          patient: hd_patient,
          user: consultant,
          terminated_on: 1.day.from_now
        )
        prescription.termination.update!(notes: "something else")

        expect(described_class.call(user: consultant)).to eq([])
      end

      it "only returns prescriptions expiring within configured period" do
        # 7 days in the future and 7 days in the past
        allow(Renalware.config).to receive_messages(
          days_ahead_to_warn_named_consultant_about_expiring_hd_prescriptions: 7,
          days_behind_to_warn_named_consultant_about_expired_hd_prescriptions: 7
        )

        _far_future_expiring_prescription = create_prescription(
          patient: hd_patient,
          user: consultant,
          terminated_on: 8.days.from_now
        )

        expiring_prescription = create_prescription(
          patient: hd_patient,
          user: consultant,
          terminated_on: 7.days.from_now
        )

        expired_prescription = create_prescription(
          patient: hd_patient,
          user: consultant,
          terminated_on: 7.days.ago
        )

        _far_past_expired_prescription = create_prescription(
          patient: hd_patient,
          user: consultant,
          terminated_on: 8.days.ago
        )

        expect(described_class.call(user: consultant))
          .to eq([expired_prescription, expiring_prescription])
      end
    end
  end
end
