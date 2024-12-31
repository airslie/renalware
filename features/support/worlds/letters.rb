module World
  module Letters
    def letters_patient(patient)
      Renalware::Letters.cast_patient(patient)
    end

    def create_contact(patient:, user:)
      address = FactoryBot.build(:address)
      person = FactoryBot.build(:directory_person, address: address, by: user)
      description = Renalware::Letters::ContactDescription[:sibling]
      FactoryBot.create(:letter_contact,
                        patient: patient,
                        person: person,
                        description: description)
    end
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/letters/*.rb")].each { |f| require f }
