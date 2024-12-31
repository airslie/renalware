describe Renalware::HD::PrescriptionAdministrationsQuery do
  let(:administrator) { create(:user, password: "password") }
  let(:witness) { create(:user, password: "password") }

  describe "validation" do
    it "raises an error if prescription is nil" do
      expect {
        described_class.new(prescription: nil).call
      }.to raise_error(ArgumentError)
    end

    it "raises an error if prescription has no patient" do
      prescription = instance_double(Renalware::Medications::Prescription, patient: nil)

      expect {
        described_class.new(prescription: prescription).call
      }.to raise_error(ArgumentError)
    end
  end

  describe "#call" do
    subject { described_class.new(prescription: prescription).call(limit: 10) }

    context "when the prescription has never been administered on HD" do
      let(:prescription) { create(:prescription) }

      it { is_expected.to be_empty }
    end

    context "when the prescription has been given once" do
      let(:prescription) { create(:prescription) }

      it "returns the record" do
        administration = create_prescription_administration_for(prescription)

        is_expected.to eq([administration])
      end
    end

    context "when a prescription administration was created but marked as not administered" do
      let(:prescription) { create(:prescription) }

      it "does not return the record" do
        create_prescription_administration_for(prescription, administered: false)

        is_expected.to be_empty
      end
    end

    context "when the prescription was given multiple times" do
      let(:prescription) { create(:prescription) }

      it "returns most recently recorded ones first, using created_at if > 1 row with " \
         "same recorded_on" do
        administrations = [
          create_prescription_administration_for(prescription, recorded_on: 1.year.ago),
          create_prescription_administration_for(prescription, recorded_on: 1.day.ago),
          create_prescription_administration_for(prescription, recorded_on: 1.day.ago),
          create_prescription_administration_for(prescription, recorded_on: 1.month.ago)
        ]

        is_expected.to eq \
          [
            administrations[2],
            administrations[1],
            administrations[3],
            administrations[0]
          ]
      end
    end

    context "when the prescription was given but not yet witnessed" do
      let(:prescription) { create(:prescription) }

      it "still returns it" do
        administration = create_prescription_administration_for(
          prescription,
          witnessed_by: nil,
          witnessed_by_password: nil,
          witness_authorised: false,
          skip_witness_validation: true
        )

        is_expected.to eq([administration])
      end
    end
  end

  def create_prescription_administration_for(prescription, **)
    create(
      :hd_prescription_administration,
      prescription: prescription,
      patient_id: prescription.patient.id,
      administered_by: administrator,
      witnessed_by: witness,
      administered_by_password: "password",
      witnessed_by_password: "password",
      administrator_authorised: true,
      witness_authorised: true,
      **
    )
  end
end
