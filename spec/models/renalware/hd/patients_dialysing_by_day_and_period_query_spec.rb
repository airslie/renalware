require "rails_helper"

module Renalware::HD
  describe PatientsDialysingByDayAndPeriodQuery do
    let(:day_of_week){ 1 } # Tuesday
    let(:diurnal_period_code){ "am" }
    let(:matching_schedule_definition) { create(:schedule_definition, :mon_wed_fri_am) }
    let(:other_schedule_definition) { create(:schedule_definition, :mon_wed_fri_pm) }

    subject(:query) { described_class.new(day_of_week, diurnal_period_code) }

    describe "#call" do
      context "when there is no matching schedule period defined" do
        let(:diurnal_period_code){ "ammmmm" }
        it "returns []" do
          expect(query.call).to eq([])
        end
      end

      context "when there are no matching patients" do
        it "returns []" do
          expect(query.call).to eq([])
        end
      end

      context "when there is a patient dialysing on this schedule" do
        it "returns the correct patient" do
          matching_patient = create(:hd_patient).tap do |patient|
            patient.hd_profile = create(:hd_profile,
                                        patient: patient,
                                        schedule_definition: matching_schedule_definition)
          end

          create(:hd_patient).tap do |other_patient|
            other_patient.hd_profile = create(:hd_profile,
                                              patient: other_patient,
                                              schedule_definition: other_schedule_definition)
          end

          expect(query.call).to eq([matching_patient])
        end
      end
    end
  end
end
