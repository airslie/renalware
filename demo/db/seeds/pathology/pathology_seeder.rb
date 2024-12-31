module Renalware
  class PathologySeeder
    def file_path_for(patient:, file_name:)
      folder = ActiveSupport::Inflector.transliterate(patient.given_name).to_s # remove cedilla
      File.join(File.dirname(__FILE__), folder.downcase, file_name)
    end

    def seed_pathology_requests_for(patient:)
      Pathology::ObservationRequest.transaction do
        Rails.benchmark "Adding Pathology Requests (OBR) for #{patient}" do
          file_path = file_path_for(patient: patient, file_name: "pathology_obr.csv")
          CSV.foreach(file_path, headers: true) do |row|
            request_desc = Pathology::RequestDescription.find_by!(code: row["description"])
            patient.observation_requests.find_or_create_by!(id: row["id"].to_i) do |obr|
              obr.description = request_desc
              obr.requestor_order_number = row["order_no"]
              obr.requested_at = row["age_in_days"].to_i.days.ago
              obr.requestor_name = row["requestor_name"]
            end
          end
        end
      end
    end

    def seed_pathology_observations_for(patient:)
      Rails.benchmark "Adding Pathology Observations (OBX) for #{patient}" do
        file_path = file_path_for(patient: patient, file_name: "pathology_obx.csv")

        observations = CSV.foreach(file_path, headers: true).map do |row|
          request = Pathology::ObservationRequest.find(row["request_id"])
          {
            request_id: request.id,
            description_id: Pathology::ObservationDescription.find_by!(code: row["description"]).id,
            result: row["result"],
            observed_at: request.requested_at + 24.hours,
            comment: row["comment"],
            created_at: Time.zone.now,
            updated_at: Time.zone.now
          }
        end
        Pathology::Observation.insert_all(observations)
      end
    end

    def seed_pathology_for(local_patient_id:)
      patient = Patient.find_by(local_patient_id: local_patient_id)
      pathology_patient = Pathology.cast_patient(patient)
      seed_pathology_requests_for(patient: pathology_patient)
      seed_pathology_observations_for(patient: pathology_patient)
    end
  end
end
