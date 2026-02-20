describe Renalware::Clinics::ClinicVisit do
  it_behaves_like "an Accountable model"
  it :aggregate_failures do
    is_expected.to be_versioned
    is_expected.to belong_to(:patient).touch(true)
    is_expected.to validate_presence_of :date
    is_expected.to validate_presence_of :clinic
    is_expected.to validate_timeliness_of(:date)
    is_expected.to validate_timeliness_of(:time)
    is_expected.not_to validate_presence_of :time
    is_expected.not_to validate_presence_of :pulse
    is_expected.not_to validate_presence_of :temperature
    is_expected.not_to validate_presence_of(:admin_notes)
    is_expected.to have_db_index(:location_id)
    is_expected.to belong_to(:location)
  end

  describe "ordered" do
    let!(:early_visit) { create(:clinic_visit, date: Time.zone.today, time: "10:00") }
    let!(:earlier_visit) { create(:clinic_visit, date: Time.zone.today, time: "09:00") }
    let!(:no_time_visit) do
      create(:clinic_visit, date: Time.zone.today, time: nil, created_at: 10.minutes.ago)
    end

    it "returns visits in the correct order" do
      expect(described_class.ordered).to eq [no_time_visit, early_visit, earlier_visit]
    end
  end

  describe "bmi" do
    subject(:visit) { create(:clinic_visit, height: 1.7, weight: 82.5, patient:) }

    let(:patient) { create(:clinics_patient, :minimal) }

    it "is calculated from height and weight" do
      expect(visit.bmi).to eq(28.5)
    end
  end

  describe "bp" do
    it "formats systolic and diastolic pressures" do
      visit = described_class.new(diastolic_bp: 85, systolic_bp: 112)

      expect(visit.bp).to eq("112/85")
    end
  end

  describe "bp=" do
    it "writes to systolic and diastolic attributes" do
      visit = described_class.new(bp: "112/82")

      expect(visit).to have_attributes(
        diastolic_bp: 82,
        systolic_bp: 112
      )
    end
  end

  describe "#body_surface_area" do
    it "calculates BSA when visit saved" do
      visit = create(
        :clinic_visit,
        weight: 100.0,
        height: 1.23,
        patient: create(:clinics_patient, :minimal)
      )

      expect(visit.reload.body_surface_area).to satisfy("be greater than 0") { it.to_i > 0 }
    end
  end

  describe "#total_body_water" do
    it "calculates TBW when visit saved" do
      visit = create(
        :clinic_visit,
        weight: 100.0,
        height: 1.23,
        patient: create(:clinics_patient, :minimal)
      )

      expect(visit.reload.total_body_water).to satisfy("be greater than 0") { it.to_i > 0 }
    end
  end

  describe "deleting a clinic visit" do
    context "when the visit was not created from an appointment" do
      it "is deleted" do
        patient = create(:clinics_patient, :minimal)
        visit = create(:clinic_visit, patient:)

        expect {
          visit.destroy
        }.to change(described_class, :count).by(-1)
      end
    end

    context "when the visit as created from an appointment" do
      it "is deleted and the appointment updated" do
        patient = create(:clinics_patient, :minimal)
        visit = create(:clinic_visit, patient:)
        appointment = create(:appointment, patient:, becomes_visit_id: visit.id)

        expect {
          visit.destroy
        }.to change(described_class, :count).by(-1)

        expect(appointment.reload.becomes_visit_id).to be_nil
      end
    end
  end
end
