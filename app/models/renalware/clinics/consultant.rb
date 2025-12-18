module Renalware
  module Clinics
    class Consultant < ApplicationRecord
      include Accountable
      include RansackAll

      acts_as_paranoid

      has_many :appointments, dependent: :restrict_with_exception

      validates :name, presence: true, uniqueness: true
      validates :code, uniqueness: true
      validates :sds_user_id, uniqueness: true

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
      # Sometime for the same consultant we will get different identifiers so we need to
      # check both when finding existing consultants.
      def self.find_or_create_by_code!(code:, name:)
        return if code.blank?

        consultant = where(code: code).or(where(sds_user_id: code)).first
        return consultant if consultant.present?

        consultant = new(name: name)
        # General Medical Council codes start with C
        # General Medical Practitioner codes start with G
        # Anything else we will assume is an SDS User ID  (Spine Directory Service)
        if code.start_with?("C", "G")
          consultant.code = code
        else
          consultant.sds_user_id = code
        end
        consultant.save!
        consultant
      end

      def to_s = name
    end
  end
end
