module Renalware
  module PD
    class OrganismCode < ApplicationRecord
      has_many :infection_organisms, dependent: :restrict_with_exception
      has_many :peritonitis_episodes,
               through: :infection_organisms,
               source: :infectable,
               source_type: "PeritonitisEpisode"
      has_many :exit_site_infections,
               through: :infection_organisms,
               source: :infectable,
               source_type: "ExitSiteInfection"
    end
  end
end
