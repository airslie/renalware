# frozen_string_literal: true

module Renalware
  module Medications
    class MedicationRoute < ApplicationRecord
      def self.table_name
        "medication_routes"
      end

      has_many :prescriptions, dependent: :restrict_with_exception
      has_many :patients, through: :prescriptions
      has_many :exit_site_infections,
               through: :prescriptions,
               source: :treatable,
               source_type: "ExitSiteInfection"
      has_many :peritonitis_episodes,
               through: :prescriptions,
               source: :treatable,
               source_type: "PeritonitisEpisode"
      validates :code, presence: true
      validates :name, presence: true

      def other?
        code.casecmp("other").zero?
      end
    end
  end
end
