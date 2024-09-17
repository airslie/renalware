# frozen_string_literal: true

describe Renalware::Clinics::BuildVisitFromAppointment do
  describe "#call" do
    let(:clinic) { build_stubbed(:clinic) }
    let(:appointment) {
      build_stubbed(:appointment,
                    patient: patient,
                    clinic: clinic,
                    starts_at: Time.zone.now)
    }

    let(:patient) { build(:clinics_patient) }
    let(:instance) { described_class.new(appointment) }

    before do
      allow(patient).to receive(:destroyed?).and_return(false)
    end

    it "creates a new clinic visit based on the appointment" do
      visit = instance.call

      expect(visit).to be_a(Renalware::Clinics::ClinicVisit)
      expect(visit.patient_id).to eq(appointment.patient_id)
      expect(visit.clinic_id).to eq(appointment.clinic_id)
      expect(visit.date).to eq(appointment.starts_at.to_date)
      expect(visit.time).to eq(appointment.starts_at.to_time)
    end

    context "when clinic has a different visit class name" do
      let(:clinic) { build_stubbed(:clinic, visit_class_name: "Renalware::Dietetics::ClinicVisit") }

      it "builds an instance of this class" do
        visit = instance.call

        expect(visit).to be_a(Renalware::Dietetics::ClinicVisit)
      end
    end
  end
end
