# frozen_string_literal: true

module Renalware
  module Patients
    extend SeedsHelper
    log "Adding ITK3 test pratice and GPs" do
      file_path = File.join(File.dirname(__FILE__), "gps.csv")

      CSV.foreach(file_path, headers: true) do |row|
        practice = Renalware::Patients::Practice.find_or_initialize_by(code: row["IDENTIFIER"])
        practice.name = row["ORG_NAME"]
        if practice.address.blank?
          practice.build_address(
            organisation_name: "ITKTEST_ORG_NAME",
            postcode: "ITKTEST_POSTCODE",
            street_1: "ITKTEST_STREET_1",
            street_2: "ITKTEST_STREET_2",
            town: "ITKTEST_TOWN"
          )
        end
        practice.save!

        Renalware::Patients::PrimaryCarePhysician
          .find_or_create_by!(code: row["PERSON_UUID"]) do |gp|
          gp.name = row["FULLNAME"]
          gp.practitioner_type = "GP"
          gp.practice_ids = [practice.id]
        end
      end
    end
  end
end
