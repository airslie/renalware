# frozen_string_literal: true

FactoryBot.define do
  factory :duke_activity_status_index_event_type, class: "Renalware::Events::Type" do
    initialize_with do
      Renalware::Events::Type.find_or_create_by(
        name: name,
        category: category
      )
    end

    category factory: :event_category
    name { "DASI score" }
    event_class_name { "Renalware::Clinical::DukeActivityStatusIndex" }
    slug { "duke_activity_status_indices" }
  end
end
