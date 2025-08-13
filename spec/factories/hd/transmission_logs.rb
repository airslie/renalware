FactoryBot.define do
  factory :hd_transmission_log, class: "Renalware::HD::TransmissionLog" do
    direction { :out }
    format { :hl7 }

    trait :outgoing_hl7

    trait :incoming_xml do
      direction { :in }
      format { :xml }
    end
  end
end
