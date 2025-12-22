module Renalware
  module Clinics
    class Consultant < ApplicationRecord
      include Accountable
      include RansackAll

      acts_as_paranoid

      has_many :appointments, dependent: :restrict_with_exception

      validates :name, presence: true, uniqueness: true
      validates :code, uniqueness: true

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

      # A consultant can be identified by either their GMC/GMP code or their SDS User ID
      # Sometime for the same consultant we will get different identifiers so we that's a bit
      # awkward. We could store all the codes, but instead for now we will match on name if no code
      # matched
      # Of note
      # General Medical Council codes start with C
      # General Medical Practitioner codes start with G
      # SDS User ID  (Spine Directory Service) is usually a 12 digit code
      # We also also receive a few other code types
      def self.find_or_create_by_code!(code:, name:)
        return if code.blank? || name.blank?

        # Find by code or name first
        consultant = where(code: code).or(where(name: name)).first
        return consultant if consultant.present?

        # create them
        create!(
          name: name,
          code: code,
          by: SystemUser.find
        )
      end

      def to_s = name
    end
  end
end
