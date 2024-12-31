module Renalware
  Rails.benchmark "Adding Modalities for Roger RABBIT" do
    rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
    file_path = File.join(File.dirname(__FILE__), "rabbit_modalities.csv")
    user = Renalware::User.first

    if rabbit.current_modality.present?
      rabbit.current_modality.terminate_by(user, on: Time.zone.now)
    end

    CSV.foreach(file_path, headers: true) do |row|
      Modalities::Modality.find_or_create_by!(
        patient_id: rabbit.id,
        description_id: row["description_id"]
      ) do |modality|
        modality.started_on = row["started_on"]
        modality.ended_on = row["ended_on"]
        modality.change_type = Modalities::ChangeType.find_by(code: "other")
        modality.by = user
      end
    end
  end
end
