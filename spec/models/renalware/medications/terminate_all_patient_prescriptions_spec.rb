# frozen_string_literal: true

module Renalware::Medications
  describe TerminateAllPatientPrescriptions do
    it "terminates all patient prescriptions but leaves untouched previously terminated ones" do
      user = create(:user)
      patient = create(:patient, by: user)

      # Create two current prescriptions
      create(:prescription, patient: patient)
      create(:prescription, patient: patient)

      # This prescription is not current - it has already been terminated.
      previously_terminated_prescription = create(
        :prescription,
        patient: patient,
        prescribed_on: "2017-01-01"
      )
      create(:prescription_termination,
             prescription: previously_terminated_prescription,
             terminated_on: "2018-01-01",
             by: user)

      # This current prescription is in the future with a future termination date also eg like a
      # future stat drug
      future_terminated_prescription = create(
        :prescription,
        patient: patient,
        prescribed_on: 1.month.from_now
      )
      create(:prescription_termination,
             prescription: future_terminated_prescription,
             terminated_on: 2.months.from_now,
             by: user)

      # This current one is to be prescribed in the future, no termination date.
      _future_unterminated_prescription = create(
        :prescription,
        patient: patient,
        prescribed_on: 1.year.from_now
      )

      expect(patient.prescriptions.current.count).to eq(4)

      expect {
        described_class.call(patient: patient, by: user)
      }.to change(patient.prescriptions.current, :count).by(-4)

      # The termination date of this one should be unchanged
      expect(previously_terminated_prescription.reload.terminated_on.to_s).to eq("2018-01-01")
    end
  end
end
