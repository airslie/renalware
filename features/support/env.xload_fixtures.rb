models = [
  Renalware::Accesses::Site,
  Renalware::Accesses::Type,
  Renalware::Accesses::Plan,
  Renalware::Accesses::CatheterInsertionTechnique,
  Renalware::Clinics::Clinic,
  Renalware::Deaths::Cause,
  Renalware::Drugs::Drug,
  Renalware::Drugs::Type,
  Renalware::Events::Type,
  Renalware::HD::CannulationType,
  Renalware::HD::Dialyser,
  Renalware::Hospitals::Centre,
  Renalware::Hospitals::Unit,
  Renalware::Letters::Letterhead,
  Renalware::Letters::ContactDescription,
  Renalware::Modalities::Description,
  Renalware::Modalities::Reason,
  Renalware::Medications::MedicationRoute,
  Renalware::Patients::Religion,
  Renalware::Patients::Language,
  Renalware::Patients::Ethnicity,
  Renalware::Pathology::ObservationDescription,
  Renalware::Pathology::Lab,
  Renalware::Pathology::RequestDescription,
  Renalware::PD::FluidDescription,
  Renalware::PD::BagType,
  Renalware::PD::System,
  Renalware::PD::OrganismCode,
  Renalware::PD::PeritonitisEpisodeTypeDescription,
  Renalware::Renal::PRDDescription,
  Renalware::Transplants::RegistrationStatusDescription,
  Renalware::Transplants::FailureCauseDescriptionGroup,
  Renalware::Transplants::FailureCauseDescription,
  Renalware::User
]

table_model_map = models.each_with_object({}) { |model, hsh| hsh[model.table_name.to_sym] = model }

Before do
  ActiveRecord::FixtureSet.reset_cache
  fixtures_folder = Renalware::Engine.root.join("features", "support", "fixtures")
  fixtures = Dir[File.join(fixtures_folder, "*.yml")].map { |f| File.basename(f, ".yml") }
  ActiveRecord::FixtureSet.create_fixtures(fixtures_folder, fixtures, table_model_map)
end
