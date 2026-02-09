module Renalware
  class CreateSwab
    def initialize
      @rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
      @swab_event_type = Events::Type.find_by(slug: "swabs")
      @user_id = Renalware::User.first.id
    end

    def call(on: 2.weeks.ago, result: "pos", type: "mrsa")
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

  Rails.benchmark "Adding Swab events for Roger RABBIT" do
    CreateSwab.new.call(on: 1.month.ago, type: "mrsa", result: "neg")
    CreateSwab.new.call(on: 1.week.ago, type: "mrsa", result: "pos")
    CreateSwab.new.call(on: 2.months.ago, type: "mssa", result: "pos")
    CreateSwab.new.call(on: 2.days.ago, type: "mssa", result: "neg")
  end
end
