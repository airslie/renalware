FactoryBot.define do
  factory :hd_transmission_log, class: "Renalware::HD::TransmissionLog" do
    trait :outgoing_hl7 do
      direction { :out }
      format { :hl7 }
    end

    trait :incoming_xml do
      direction { :in }
      format { :xml }
    end
  end
end
