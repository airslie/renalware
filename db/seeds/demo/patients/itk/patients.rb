module Renalware
  module Patients
    Rails.benchmark "Adding ITK3 test patients" do
      file_path = File.join(File.dirname(__FILE__), "patients.csv")
      sex_map = { "Male" => "M", "Female" => "F", "Indeterminate" => "NK", "Not known" => "NK" }
      idx = 0
      user = Renalware::SystemUser.find

      CSV.foreach(file_path, headers: true) do |row|
        idx += 1
        patient = Renalware::Patient.find_or_initialize_by(
          nhs_number: row["NHS_NUMBER"]
        ) do |pat|
          pat.family_name = row["FAMILY_NAME"]
          pat.given_name = row["GIVEN_NAME"]
          pat.title = row["TITLE"]
          pat.sex = sex_map[row["GENDER"]]
          pat.born_on = "1970-01-01"
          pat.local_patient_id = "ITK_#{idx}"
        end
        patient.practice = Practice.find_by!(code: row["PRIMARY_CARE_CODE"])
        address = patient.current_address || patient.build_current_address
        address.street_1 = row["ADDR1"]
        address.street_2 = row["ADDR2"]
        address.town = row["ADDR3"]
        address.county = row["ADDR4"]
        address.postcode = row["POST_CODE"]

        patient.save_by!(user)
      end
    end
  end
end
