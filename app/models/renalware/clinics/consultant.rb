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
      # Scenarios
      # 1. Consultant not known so we save their name and code in the relevant column
      # 2. Consultant present and matches on the incoming code (gmc or sds)
      # 3. Consultant but the code we have is not the incoming one. For example we know them
      #   as Name: 'Jane Smith' GMC code: 'C123', but incoming is 'Jane Smith' SDS id: '123'
      #   so in this instance we must try to match them by name, and if we find them, update the
      #   sds_user_id col with the incoming code.
      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
      # rubocop:disable Metrics/PerceivedComplexity
      def self.find_or_create_by_code!(code:, name:)
        return if code.blank?

        gmc_code = nil
        sds_user_id = nil

        # General Medical Council codes start with C
        # General Medical Practitioner codes start with G
        # Anything else we will assume is an SDS User ID  (Spine Directory Service)
        consultant =  if code.start_with?("C", "G")
                        gmc_code = code
                        find_by(code: gmc_code)
                      else
                        sds_user_id = code
                        find_by(sds_user_id:)
                      end

        return consultant if consultant.present?

        # Not found so try searching by name
        consultant = find_by(name: name)
        if consultant.present?
          consultant.code = gmc_code if gmc_code && consultant.code.blank?
          consultant.sds_user_id = sds_user_id if sds_user_id && consultant.sds_user_id.blank?
          consultant.save!(by: SystemUser.find)
        end

        return consultant if consultant.present?

        # We could not fins the consultant by either code, sds id or name so create them
        create!(
          name: name,
          code: gmc_code,
          sds_user_id: sds_user_id,
          by: SystemUser.find
        )
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength
      # rubocop:enable Metrics/PerceivedComplexity

      def to_s = name
    end
  end
end
