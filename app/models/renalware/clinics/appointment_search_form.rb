module Renalware
  module Clinics
    class AppointmentSearchForm
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :from_date, :date, default: -> { Time.zone.today }
      attribute :from_date_only, :boolean
      attribute :clinic_id, :integer
      attribute :consultant_id, :integer
      attribute :s, array: true # ransack sort_links

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
