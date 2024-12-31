module Renalware
  module PD
    class PeritonitisEpisode < ApplicationRecord
      include PatientScope

      belongs_to :patient, class_name: "Renalware::Patient", touch: true
      has_many :episode_types, class_name: "PD::PeritonitisEpisodeType"
      belongs_to :fluid_description

      has_many :prescriptions, as: :treatable, class_name: "Renalware::Medications::Prescription"
      has_many :medication_routes, through: :prescriptions
      has_many :patients, through: :prescriptions, as: :treatable
      has_many :infection_organisms, as: :infectable
      has_many :organism_codes, -> { uniq }, through: :infection_organisms, as: :infectable

      validates :patient, presence: true
      validates :diagnosis_date, presence: true

      scope :ordered, -> { order(diagnosis_date: :desc) }
    end
  end
end
