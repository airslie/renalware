FactoryBot.define do
  factory :hd_station, class: "Renalware::HD::Station" do
    accountable
    name { "StationA" }
    hospital_unit
  end
end
