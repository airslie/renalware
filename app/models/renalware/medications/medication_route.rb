module Renalware
  module Medications
    class MedicationRoute < ApplicationRecord
      # Renalware Registry Dataset v5 codes
      RR22_CODES = {
        "Oral" => 1,
        "Topical" => 2,
        "Inhalation" => 3,
        "Injection" => 4,
        "Intra peritoneal" => 5,
        "Other" => 9
      }.freeze

      def self.table_name = "medication_routes"
      def self.rr22_code_for(name) = RR22_CODES.fetch(name, 9)

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
      validates :rr_code, presence: true # underlying column can be null, that's fine.

      def other?
        name.casecmp("Other").zero?
      end
    end
  end
end
