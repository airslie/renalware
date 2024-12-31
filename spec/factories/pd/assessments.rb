FactoryBot.define do
  factory :pd_assessment, class: "Renalware::PD::Assessment" do
    accountable
    patient
    document {
      {
        assessed_on: Time.zone.today,
        assessor: "Flo Nightengale RN",
        had_home_visit: :yes,
        home_visit_on: Time.zone.today,
        housing_type: :flat,
        occupant_notes: "occupant notes...",
        exchange_area: "exchange area...",
        handwashing: "handwashing...",
        fluid_storage: "fluid storage...",
        bag_warming: "bag warming...",
        delivery_interval: "P1W"
      }
    }
  end
end
