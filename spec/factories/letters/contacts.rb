FactoryBot.define do
  factory :letter_contact, class: "Renalware::Letters::Contact" do
    description factory: :letter_contact_description
    person factory: :directory_person
    patient factory: :letter_patient
  end
end
