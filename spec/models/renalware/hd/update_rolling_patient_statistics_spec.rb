module Renalware::HD
  describe UpdateRollingPatientStatistics do
    subject(:command) { described_class.new(patient:) }

    let(:patient) { create(:hd_patient, by:) }
    let(:user) { create(:user) }
    let(:by) { user }
    let(:hospital_unit) { create(:hospital_unit) }
    let(:hospital_unit2) { create(:hospital_unit) }

    it "creates a new rolling PatientStatistics row if one did not exist" do
      expect(PatientStatistics.count).to eq(0)

      create(:hd_open_session, patient:, by:, hospital_unit:)
      create(:hd_closed_session, patient:, by:, hospital_unit:)
      create(:hd_closed_session, patient:, by:, hospital_unit:)
      create(:hd_dna_session, patient:, by:, hospital_unit:)

      command.call

      expect(PatientStatistics.count).to eq(1)
      patient_statistics = PatientStatistics.first
      expect(patient_statistics.hospital_unit).to eq(hospital_unit)
      expect(patient_statistics.session_count).to eq(3) # excludes open

      Sessions::AuditableSessionCollection::AUDITABLE_ATTRIBUTES.each do |attr|
        expect(patient_statistics[attr]).not_to be_nil
      end
    end

    context "when the hd profile has a hospital unit" do
      it "assigns that to the stats record" do
        expect(PatientStatistics.count).to eq(0)

        create(:hd_profile, patient:, hospital_unit: hospital_unit2, by:)

        # Lets assume some migrated sessions have no hospital unit set
        create(:hd_closed_session, patient:, by:, hospital_unit:)

        command.call

        expect(PatientStatistics.count).to eq(1)
        expect(PatientStatistics.first.hospital_unit).to eq(hospital_unit2)
      end
    end

    context "when the hd profile unit unset then use unit from the most recent session" do
      it "assigns that to the stats record" do
        expect(PatientStatistics.count).to eq(0)

        create(:hd_profile, patient:, hospital_unit: nil, by:)

        # Lets assume some migrated sessions have no hospital unit set
        create(:hd_closed_session, patient:, by:, hospital_unit: hospital_unit2)

        command.call

        expect(PatientStatistics.count).to eq(1)
        expect(PatientStatistics.first.hospital_unit).to eq(hospital_unit2)
      end
    end

    context "when the hd profile not set and no hospital unit on sessions" do
      it "don't save the stats" do
        expect(PatientStatistics.count).to eq(0)

        create(:hd_profile, patient:, hospital_unit: nil, by:)

        # Lets assume some migrated sessions have no hospital unit set
        build(:hd_closed_session, patient:, by:, hospital_unit: nil)
          .save(validate: false)

        command.call

        expect(PatientStatistics.count).to eq(0)
      end
    end
  end
end
