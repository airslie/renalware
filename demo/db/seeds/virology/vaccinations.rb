module Renalware
  Rails.benchmark "Adding Vaccination events for Roger RABBIT" do
    class CreateVaccination
      def initialize
        @rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
        @vaccination_event_type = Events::Type.find_by!(name: "Vaccination")
        @user_id = Renalware::User.first.id
      end

      def call(on: 1.day.ago, vaccination_type: :covid19_1, drug: "Pfizer COVID-19 Vaccine")
        Virology::Vaccination.new(
          patient_id: @rabbit.id,
          event_type_id: @vaccination_event_type.id,
          notes: Faker::Lorem.sentence,
          date_time: on,
          created_at: on,
          updated_at: on,
          created_by_id: @user_id,
          updated_by_id: @user_id,
          document: {
            type: vaccination_type,
            drug: drug
          }
        ).save!
      end
    end

    CreateVaccination.new.call(
      on: Time.zone.now - 1.month,
      vaccination_type: :covid19_1,
      drug: "Pfizer COVID-19 Vaccine"
    )
    CreateVaccination.new.call(
      on: Time.zone.now - 1.day,
      vaccination_type: :covid19_2,
      drug: "Pfizer COVID-19 Vaccine"
    )
    CreateVaccination.new.call(
      on: Time.zone.now - 1.day,
      vaccination_type: :hbv1,
      drug: "HBV Vaccine"
    )
  end
end
