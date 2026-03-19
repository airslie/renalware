module Renalware
  class CreateBiopsy
    def initialize
      @rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
      @biopsy_event_type = Events::Type.find_by!(name: "Renal Biopsy Native")
      @user_id = Renalware::User.first.id
    end

    def call(on: 2.weeks.ago,
             result1: Events::Biopsy::Document.result1.values.first,
             result2: Events::Biopsy::Document.result2.values.last)
      Events::Biopsy.new(
        patient_id: @rabbit.id,
        event_type_id: @biopsy_event_type.id,
        notes: Faker::Lorem.sentence,
        date_time: on,
        created_by_id: @user_id,
        updated_by_id: @user_id,
        document: {
          result1: result1,
          result2: result2
        }
      ).save!
    end
  end

  Rails.benchmark "Adding Biopsy events for Roger RABBIT" do
    CreateBiopsy.new.call(on: 1.month.ago)
    CreateBiopsy.new.call(on: 1.week.ago)
  end
end
