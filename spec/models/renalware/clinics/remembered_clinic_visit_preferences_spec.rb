module Renalware
  module Clinics
    describe RememberedClinicVisitPreferences do
      describe "#persist" do
        it "saves certain model attributes to the session" do
          visit = instance_double(ClinicVisit, date: Time.zone.now, clinic_id: 1)
          session = {}

          described_class.new(session).persist(visit)

          RememberedClinicVisitPreferences::ATTRIBUTES_TO_REMEMBER.each do |attr|
            expect(session[:clinic_visit_preferences]).to have_key(attr)
          end
        end
      end

      describe "#apply_to" do
        it "copies any previously remembered session data to the visit" do
          date = Time.zone.now
          clinic_id = 1
          session = { clinic_visit_preferences: { date: date, clinic_id: clinic_id } }
          visit = OpenStruct.new(date: nil, clinic_id: nil)

          described_class.new(session).apply_to(visit)

          expect(visit).to have_attributes(date: date, clinic_id: clinic_id)
        end
      end
    end
  end
end
