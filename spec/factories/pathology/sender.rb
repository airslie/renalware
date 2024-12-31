FactoryBot.define do
  factory :pathology_sender, class: "Renalware::Pathology::Sender" do
    initialize_with do
      Renalware::Pathology::Sender.find_or_create_by!(
        sending_facility: sending_facility,
        sending_application: sending_application
      )
    end

    sending_facility { "Facility1" }
    sending_application { "*" }
  end
end
