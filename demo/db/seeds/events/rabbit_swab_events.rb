module Renalware
  Rails.benchmark "Adding Swab events for Roger RABBIT" do
    class CreateSwab
      def initialize
        @rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
        @swab_event_type = Events::Type.find_by(slug: "swabs")
        @user_id = Renalware::User.first.id
      end

      def call(on: Time.zone.now - 2.weeks,
               result: "pos",
               type: "mrsa",
               notes: "Lorem ipusm")
        Events::Swab.new(
          patient_id: @rabbit.id,
          event_type_id: @swab_event_type.id,
          notes: Faker::Lorem.sentence,
          date_time: on,
          created_by_id: @user_id,
          updated_by_id: @user_id,
          document: {
            type: type,
            result: result
          }
        ).save!
      end
    end

    CreateSwab.new.call(on: Time.zone.now - 1.month, type: "mrsa", result: "neg")
    CreateSwab.new.call(on: Time.zone.now - 1.week, type: "mrsa", result: "pos")
    CreateSwab.new.call(on: Time.zone.now - 2.months, type: "mssa", result: "pos")
    CreateSwab.new.call(on: Time.zone.now - 2.days, type: "mssa", result: "neg")
  end
end
