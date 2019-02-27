# frozen_string_literal: true

module World
  module Users
    def create_user(given_name:, family_name:)
      Renalware::User.create!(
        family_name: family_name,
        given_name: given_name,
        email: "#{given_name}.#{family_name}@renalware.net",
        username: "#{given_name}_#{family_name}",
        approved: true,
        password: "supersecret",
        hospital_centre: Renalware::Hospitals::Centre.first
      )
    end
  end
end
