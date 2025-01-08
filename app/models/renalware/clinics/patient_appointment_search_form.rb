# frozen_string_literal: true

module Renalware
  module Clinics
    class PatientAppointmentSearchForm
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :patient
      attribute :clinic_id, :integer
      attribute :consultant_id, :integer
      attribute :s, array: true # ransack sort_links

      def query
        @query ||= AppointmentQuery.new(relation: patient.appointments, q: query_options)
      end

      private

      def query_options
        {
          clinic_id_eq: clinic_id,
          consultant_id_eq: consultant_id,
          s: s
        }
      end
    end
  end
end
