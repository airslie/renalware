FactoryBot.define do
  factory :hd_slot_request_access_state, class: "Renalware::HD::SlotRequests::AccessState" do
    name { Faker::Lorem.word }
    position { 0 }
  end
end
