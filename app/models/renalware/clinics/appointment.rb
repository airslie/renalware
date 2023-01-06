# frozen_string_literal: true

module Renalware
  module Clinics
    class Appointment < ApplicationRecord
      include Accountable
      belongs_to :patient, touch: true
      belongs_to :consultant, -> { with_deleted }, counter_cache: true
      belongs_to :clinic, -> { with_deleted }, counter_cache: true

      validates :starts_at, presence: true
      validates :patient_id, presence: true
      validates :clinic_id, presence: true
      validates :starts_at, timeliness: { type: :datetime }

      def starts_on
        starts_at.to_date
      end

      def start_time
        starts_at.strftime("%H:%M")
      end
    end
  end
end
