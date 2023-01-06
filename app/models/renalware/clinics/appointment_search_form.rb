# frozen_string_literal: true

# rubocop:disable Rails/AttributeDefaultBlockValue
module Renalware
  module Clinics
    class AppointmentSearchForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :from_date, Date, default: Time.zone.today
      attribute :from_date_only, Boolean
      attribute :clinic_id, Integer
      attribute :consultant_id, Integer
      attribute :s, String # ransack sort_links

      def query
        @query ||= AppointmentQuery.new(query_options)
      end

      private

      def query_options
        {
          clinic_id_eq: clinic_id,
          consultant_id_eq: consultant_id,
          s: s
        }.merge(date_options)
      end

      def date_options
        return {} if from_date.blank?

        from_date_only ? { starts_on_eq: from_date } : { starts_on_gteq: from_date }
      end
    end
  end
end
# rubocop:enable Rails/AttributeDefaultBlockValue
