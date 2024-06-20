# frozen_string_literal: true

module Renalware
  module Medications
    class MedicationRoute < ApplicationRecord
      def self.table_name
        "medication_routes"
      end

      has_many :prescriptions, dependent: :restrict_with_exception
      has_many :patients, through: :prescriptions
      has_many :vmp_classifications, class_name: "Drugs::VMPClassification",
                                     dependent: :nullify, foreign_key: :route_id
      has_many :drugs, through: :vmp_classifications

      has_many :exit_site_infections,
               through: :prescriptions,
               source: :treatable,
               source_type: "ExitSiteInfection"
      has_many :peritonitis_episodes,
               through: :prescriptions,
               source: :treatable,
               source_type: "PeritonitisEpisode"

      scope :for_drug_id, lambda { |drug_id|
                            joins(:vmp_classifications)
                              .merge(Drugs::VMPClassification.where(drug_id: drug_id))
                              .distinct
                          }
      scope :ordered, -> { order(weighting: :desc, name: :asc) }
      validates :code, presence: true
      validates :name, presence: true

      def other?
        name.casecmp("Other").zero?
      end
    end
  end
end
