module Renalware
  Rails.benchmark "Assign contacts to Roger RABBIT" do
    patient = Letters.cast_patient(Patient.find_by(local_patient_id: "Z100001"))

    people = Directory::Person.limit(5)
    contact_descriptions = Letters::ContactDescription.specified.limit(5)
    # add default here in case we don't have enough descriptions
    default_contact_description = Letters::ContactDescription[:sibling]

    people.zip(contact_descriptions).each do |person, contact_description|
      next if patient.contacts.map(&:person_id).include?(person.id)

      patient
        .assign_contact(
          person: person,
          description: contact_description || default_contact_description
        ).save!
    end
  end
end
