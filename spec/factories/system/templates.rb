FactoryBot.define do
  factory :esi_printable_form_template, class: "Renalware::System::Template" do
    name { "esi_printable_form" }
    title { "ESI Printable Form" }
    description { "Description" }
    body { "{{ patient.name }} {{ patient.hospital_identifier }}" }
  end

  factory :peritonitis_episode_printable_form_template, class: "Renalware::System::Template" do
    name { "peritonitis_episode_printable_form" }
    title { "Peritonitis Episode Printable form" }
    description { "Description" }
    body { "{{ patient.name }} {{ patient.hospital_identifier }}" }
  end
end
