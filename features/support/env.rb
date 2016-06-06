require "simplecov"

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

# Tell cucumber-rails where rails lives
ENV["RAILS_ROOT"] = Dir.pwd

require "cucumber/rails"
WebMock.disable!
# Capybara defaults to CSS3 selectors rather than XPath.
# If you"d prefer to use XPath, just uncomment this line and adjust any
# selectors in your step definitions to use the XPath syntax.
# Capybara.default_selector = :xpath
Capybara.default_wait_time = 5 # in seconds

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Load the test fixtures to the database
table_model_map = {
  access_plans: Renalware::Accesses::Plan,
  access_sites: Renalware::Accesses::Site,
  access_types: Renalware::Accesses::Type,
  addresses: Renalware::Address,
  bag_types: Renalware::BagType,
  clinics: Renalware::Clinics::Clinic,
  doctors: Renalware::Doctor,
  drug_types: Renalware::Drugs::Type,
  drugs: Renalware::Drugs::Drug,
  edta_codes: Renalware::EdtaCode,
  episode_types: Renalware::EpisodeType,
  ethnicities: Renalware::Ethnicity,
  event_types: Renalware::Events::Type,
  fluid_descriptions: Renalware::FluidDescription,
  hd_cannulation_types: Renalware::HD::CannulationType,
  hd_dialysers: Renalware::HD::Dialyser,
  hospital_centres: Renalware::Hospitals::Centre,
  hospital_units: Renalware::Hospitals::Unit,
  letter_letterheads: Renalware::Letters::Letterhead,
  medication_routes: Renalware::MedicationRoute,
  modality_descriptions: Renalware::Modalities::Description,
  modality_reasons: Renalware::Modalities::Reason,
  organism_codes: Renalware::OrganismCode,
  pathology_lab: Renalware::Pathology::Lab,
  pathology_observation_descriptions: Renalware::Pathology::ObservationDescription,
  pathology_request_descriptions: Renalware::Pathology::RequestDescription,
  patient_languages: Renalware::Patients::Language,
  patient_religions: Renalware::Patients::Religion,
  practices: Renalware::Practice,
  prd_descriptions: Renalware::PRDDescription,
  roles: Renalware::Role,
  transplant_failure_cause_description_groups: Renalware::Transplants::FailureCauseDescriptionGroup,
  transplant_failure_cause_descriptions: Renalware::Transplants::FailureCauseDescription,
  transplant_registration_status_descriptions:
    Renalware::Transplants::RegistrationStatusDescription,
  users: Renalware::User,
}

Before do
  ActiveRecord::FixtureSet.reset_cache
  fixtures_folder = File.join(Rails.root, "features", "support", "fixtures")
  fixtures = Dir[File.join(fixtures_folder, "*.yml")].map {|f| File.basename(f, ".yml") }
  ActiveRecord::FixtureSet.create_fixtures(fixtures_folder, fixtures, table_model_map)
end

puts "Database fixtures loaded."

