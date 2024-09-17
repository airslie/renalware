# frozen_string_literal: true

# We also implictly testing AppointmentQuery here.
# Note there is a known ransacker issue where if there was an appointment at 00:00 in 5-Apr
# created in BST then it will be stored in UTC as 23:00 4-Apr and the ransacker :started_on in
# AppointmentQuery does not apply the timezone so will not find this appointment if
# AppointmentSearchForm#from_date is 5-Apr.
describe Renalware::Clinics::AppointmentSearchForm do
  describe "#query" do
    context "when there is no from_date" do
      it "returns all appointments" do
        patient = create(:clinics_patient)
        app1 = create(:appointment, patient: patient, starts_at: 1.year.ago)
        app2 = create(:appointment, patient: patient, starts_at: 1.year.from_now)

        appointments = described_class.new(from_date: nil).query.call

        expect(appointments.map(&:id)).to eq([app1.id, app2.id])
      end
    end

    context "when from_date is present" do
      it "finds appointments starting from that day" do
        patient = create(:clinics_patient)
        date = Time.zone.today
        app1 = create(:appointment, patient: patient, starts_at: date + 3.hours)
        app2 = create(:appointment, patient: patient, starts_at: date + 3.days)
        create(:appointment, patient: patient, starts_at: date - 3.hours)

        appointments = described_class.new(from_date: date).query.call

        expect(appointments.map(&:id)).to eq(
          [
            app1.id, app2.id
          ]
        )
      end
    end

    context "when from_date is present and from_date_only is true" do
      it "finds appointments just on that day" do
        patient = create(:clinics_patient)
        date = Time.zone.today
        create(:appointment, patient: patient, starts_at: date + 1.day + 1.hour)
        app2 = create(:appointment, patient: patient, starts_at: date + 3.hours)
        create(:appointment, patient: patient, starts_at: date - 3.hours)

        appointments = described_class.new(
          from_date: date,
          from_date_only: true
        ).query.call

        expect(appointments.pluck(:id)).to eq([app2.id])
      end
    end
  end
end
