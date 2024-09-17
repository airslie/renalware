# frozen_string_literal: true

module Renalware
  extend SeedsHelper

  log "Adding Patients" do
    without_papertrail_versioning_for(Patient) do
      file_path = Rails.root.join(File.dirname(__FILE__), "patients.csv")
      system_user = SystemUser.find
      countries = System::Country.all
      patients = []
      host_hospital_centre_id = Hospitals::Centre
        .where(host_site: true)
        .order(:name)
        .pick(:id)

      Patient.transaction do
        CSV.foreach(file_path, headers: true) do |row|
          nhs_number = row["nhs_number"]
          break if nhs_number.blank?

          pat = Patient.find_or_initialize_by(nhs_number: nhs_number) do |patient|
            patient.local_patient_id = row["local_patient_id"]
            patient.family_name = row["family_name"]
            patient.given_name = row["given_name"]
            patient.sex = row["sex"]
            patient.born_on = row["born_on"]
            patient.created_at = row["created_at"]
            patient.send_to_rpv = row["send_to_rpv"]
            patient.created_by_id = system_user.id
            patient.updated_by_id = system_user.id
            patient.ukrdc_external_id = SecureRandom.uuid
            patient.secure_id = SecureRandom.uuid
            patient.generate_renal_registry_id
            patient.hospital_centre_id = host_hospital_centre_id
          end

          address = pat.current_address || pat.build_current_address
          address.street_1 = Faker::Address.secondary_address
          address.street_2 = Faker::Address.street_address
          address.town = Faker::Address.city
          address.county = Faker::Address.state
          address.postcode = Faker::Address.postcode
          address.country = countries.sample
          patients << pat
        end

        Patient.import! patients
      end
    end
  end
end
