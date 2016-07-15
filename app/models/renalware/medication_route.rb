module Renalware
  class MedicationRoute < ActiveRecord::Base
    has_many :prescriptions
    has_many :patients, through: :prescriptions
    has_many :exit_site_infections, through: :prescriptions,
      source: :treatable, source_type: "ExitSiteInfection"
    has_many :peritonitis_episodes, through: :prescriptions,
      source: :treatable, source_type: "PeritonitisEpisode"

    def other?
      code == "Other"
    end
  end
end
