# frozen_string_literal: true

module Renalware
  module Admissions
    # rubocop:disable Rails/Pick
    class ActiveConsultAlertComponent < ApplicationComponent
      include IconHelper

      pattr_initialize [:current_user, :patient!]

      def consult_id
        @consult_id ||= Consult
          .where(patient_id: patient.id, ended_on: nil)
          .order(started_on: :desc)
          .pluck(:id)
          .first
      end

      def render?
        consult_id.present?
      end
    end
    # rubocop:enable Rails/Pick
  end
end
