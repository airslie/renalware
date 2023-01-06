# frozen_string_literal: true

module Renalware
  module Clinics
    class Clinic < ApplicationRecord
      include Accountable
      acts_as_paranoid

      # The dependent option is not really compatible with acts_as_paranoid
      # rubocop:disable Rails/HasManyOrHasOneDependent
      has_many :clinic_visits
      has_many :appointments
      # rubocop:enable Rails/HasManyOrHasOneDependent

      belongs_to :default_modality_description, class_name: "Modalities::Description"

      validates :name, presence: true, uniqueness: true
      validates :code, uniqueness: true

      scope :ordered, -> { order(deleted_at: :desc, name: :asc) }
      scope :with_last_clinic_visit_date, lambda {
        select(<<-SQL.squish)
          (SELECT max(clinic_visits.date)
          FROM clinic_visits
          WHERE clinic_visits.clinic_id=clinic_clinics.id) AS last_clinic_visit
        SQL
      }
      scope :with_last_appointment_time, lambda {
        select(<<-SQL.squish)
          (SELECT max(clinic_appointments.starts_at)
          FROM clinic_appointments
          WHERE clinic_appointments.clinic_id=clinic_clinics.id) AS last_clinic_appointment
        SQL
      }

      # Note sure if needed so commenting out
      # belongs_to :consultant, class_name: "Renalware::User", foreign_key: :user_id

      def to_s
        name
      end

      def description
        [name, code].reject(&:blank?).uniq.join(Renalware.config.clinic_name_code_separator)
      end
    end
  end
end
