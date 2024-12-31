module Renalware
  module PD
    class ExitSiteInfection < ApplicationRecord
      include PatientScope
      extend Enumerize

      belongs_to :patient, class_name: "Renalware::Patient", touch: true

      # clinical_presentation serializes to a pg array e.g. {pus,swabbed,tunnel_infection}
      enumerize :clinical_presentation,
                in: [:pain, :redness, :swelling, :pus, :swabbed, :tunnel_infection],
                multiple: true

      has_many :prescriptions, as: :treatable, class_name: "Renalware::Medications::Prescription"
      has_many :medication_routes, through: :prescriptions
      has_many :patients, through: :prescriptions, as: :treatable
      has_many :infection_organisms, as: :infectable
      has_many :organism_codes, -> { uniq }, through: :infection_organisms, as: :infectable

      validates :patient, presence: true
      validates :diagnosis_date, presence: true

      scope :ordered, -> { order(diagnosis_date: :desc) }

      def self.policy_class = BasePolicy
    end
  end
end
