require_dependency "renalware"
require "document/base"

module Renalware
  class Patient < ActiveRecord::Base
    include PatientsRansackHelper
    include Personable
    include Accountable
    include Document::Base
    extend Enumerize

    enumerize :marital_status, in: %i(married single divorced widowed)

    serialize :sex, Gender

    has_one :current_address, as: :addressable, class_name: "Address"
    belongs_to :ethnicity
    belongs_to :first_edta_code, class_name: "EdtaCode", foreign_key: :first_edta_code_id
    belongs_to :second_edta_code, class_name: "EdtaCode", foreign_key: :second_edta_code_id
    belongs_to :doctor
    belongs_to :practice
    belongs_to :religion, class_name: "Patients::Religion"
    belongs_to :language, class_name: "Patients::Language"

    has_many :exit_site_infections
    has_many :peritonitis_episodes
    has_many :problems, class_name: "Problems::Problem"
    has_many :medications
    has_many :drugs, through: :medications
    has_many :medication_routes, through: :medications
    has_many :modalities, class_name: "Modalities::Modality"
    has_many :pd_regimes

    has_one :current_modality, -> { order(started_on: :desc).where(deleted_at: nil) },
      class_name: "Modalities::Modality"
    has_one :modality_description, through: :current_modality,
      class_name: "Modalities::Description", source: :description

    has_document class_name: "Renalware::PatientDocument"

    accepts_nested_attributes_for :current_address
    accepts_nested_attributes_for :medications, allow_destroy: true

    validates :nhs_number, length: { minimum: 10, maximum: 10 }, uniqueness: true, allow_blank: true
    validates :family_name, presence: true
    validates :given_name, presence: true
    validates :local_patient_id, presence: true, uniqueness: true
    validates :born_on, presence: true
    validate :validate_sex
    validates :born_on, timeliness: { type: :date }
    validates :email, email: true, allow_blank: true

    with_options if: :current_modality_death?, on: :update do |death|
      death.validates :died_on, presence: true
      death.validates :died_on, timeliness: { type: :date }
      death.validates :first_edta_code_id, presence: true
    end

    scope :dead, -> { where.not(died_on: nil) }

    def self.policy_class
      BasePolicy
    end

    def age
      now = Time.now.utc.to_date
      now.year - born_on.year - (
        (now.month > born_on.month ||
          (now.month == born_on.month && now.day >= born_on.day)
        ) ? 0 : 1
      )
    end

    def assigned_to_doctor?(doctor)
      self.doctor == doctor
    end

    # @section services

    def set_modality(attrs)
      if current_modality.present?
        current_modality.transfer!(attrs)
      else
        modalities.create(attrs)
      end
    end

    def current_modality_death?
      if self.current_modality.present?
        self.current_modality.description.death?
      end
    end

    def current_modality_live_donor?
      if self.current_modality.present?
        self.current_modality.description.donation?
      end
    end

    private

    def validate_sex
      errors.add(:sex, "is invalid option (#{sex.code})") unless sex.valid?
    end
  end
end
