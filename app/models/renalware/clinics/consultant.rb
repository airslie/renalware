module Renalware
  module Clinics
    class Consultant < ApplicationRecord
      include Accountable
      include RansackAll
      acts_as_paranoid

      has_many :appointments, dependent: :restrict_with_exception

      validates :name, presence: true, uniqueness: true
      validates :code, presence: true, uniqueness: true

      scope :ordered, -> { order(deleted_at: :desc, name: :asc) }
      scope :with_last_appointment_date, lambda {
        select(<<-SQL.squish)
          (
            SELECT max(clinic_appointments.starts_at)
            FROM clinic_appointments
            WHERE clinic_appointments.consultant_id = clinic_consultants.id
          ) AS last_appointment_date
        SQL
      }

      def to_s = name
    end
  end
end
