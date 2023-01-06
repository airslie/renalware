# frozen_string_literal: true

module Renalware
  log "Adding demo clinic with an associated clinic visit class with custom fields" do
    Clinics::Clinic.find_or_create_by!(name: "MyClinic", code: "myclinic") do |cli|
      cli.default_modality_description = Modalities::Description.find_by(code: "nephrology")
      cli.visit_class_name = "Clinics::MyVisit"
    end
  end

  log "Adding Visit Class Name to Dietetic clinic" do
    dietetic_clinic = Renalware::Clinics::Clinic.where(name: "Dietitians").first
    dietetic_clinic.visit_class_name = "Renalware::Dietetics::ClinicVisit"
    dietetic_clinic.save!
  end
end
