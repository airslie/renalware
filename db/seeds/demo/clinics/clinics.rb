module Renalware
  Rails.benchmark "Adding Clinics" do
    file_path = File.join(File.dirname(__FILE__), "clinics.csv")
    neph = Modalities::Description.find_by!(code: "nephrology")
    CSV.foreach(file_path, headers: true) do |row|
      Clinics::Clinic.find_or_create_by!(name: row["name"], code: row["code"]) do |cli|
        cli.default_modality_description = neph
      end
    end
  end

  Rails.benchmark "Adding demo clinic with an associated clinic visit class with custom fields" do
    Clinics::Clinic.find_or_create_by!(name: "MyClinic", code: "myclinic") do |cli|
      cli.default_modality_description = Modalities::Description.find_by!(code: "nephrology")
      cli.visit_class_name = "Clinics::MyVisit"
    end
  end

  Rails.benchmark "Adding Visit Class Name to Dietetic clinic" do
    dietetic_clinic = Clinics::Clinic.where(name: "Dietitians").first
    dietetic_clinic.visit_class_name = "Renalware::Dietetics::ClinicVisit"
    dietetic_clinic.save!
  end
end
