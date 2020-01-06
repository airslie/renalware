# frozen_string_literal: true

module World
  module Global
    def find_link_in_row_with(text:, link_label:)
      find(:xpath, "//tr[td[contains(.,'#{text}')]]/td/a", text: link_label)
    end

    def transplant_hospital
      Renalware::Hospitals::Centre.find_by(is_transplant_site: true)
    end

    def hd_unit
      Renalware::Hospitals::Unit.hd_sites.first
    end

    def find_or_create_user(given_name:, role:)
      return nil if given_name.blank?

      user = Renalware::User.find_by(given_name: given_name)
      if user.blank?
        email_name = given_name.gsub(/\s+/, "_").downcase

        user = Renalware::User.create!(
          given_name: given_name,
          family_name: "A User",
          username: given_name,
          email: "#{email_name}@renalware.com",
          password: "supersecret",
          approved: true,
          hospital_centre: Renalware::Hospitals::Centre.first
        )
      end
      user.roles << Renalware::Role.find_or_create_by(name: role) unless user.roles.any?
      user
    end

    def create_patient(full_name:)
      Renalware::Patient.create!(
        family_name: full_name.split(",").first.strip,
        given_name: full_name.split(",").last.strip,
        nhs_number: rand(10000000).to_s.rjust(10, "1234567890"),
        local_patient_id: rand(10000).to_s.rjust(6, "Z99999"),
        sex: "M",
        born_on: Time.zone.today,
        by: Renalware::SystemUser.find
      )
    end

    def primary_care_physician
      @primary_care_physician ||= FactoryBot.create(:primary_care_physician)
    end
  end
end
