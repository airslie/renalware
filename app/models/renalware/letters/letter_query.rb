module Renalware
  module Letters
    module QueryableLetter
      extend ActiveSupport::Concern
      included do
        def self.ransackable_attributes(*)
          super + %w(effective_date)
        end

        def self.state_eq(state = :draft)
          where(type: Letter.state_class_name(state))
        end

        def self.clinic_visit_clinic_id_eq(clinic_id)
          # Ransack scope issue, see https://github.com/activerecord-hackery/ransack/issues/593
          # if the clinic_id is 1 it maps it to true, so revert this.
          # There is a way to add a global setting to prevent this happening but I am not sure
          # of the knock-on effects of doing this elsewhere in the app.
          clinic_id = 1 if clinic_id == true

          join_sql = <<-SQL.squish
            inner join clinic_visits
              on clinic_visits.clinic_id = ?
              and clinic_visits.id = letter_letters.event_id
              and letter_letters.event_type = ?
          SQL
          sanitized_join_sql = sanitize_sql_array(
            [
              join_sql,
              clinic_id,
              Renalware::Clinics::ClinicVisit.name
            ]
          )
          joins(sanitized_join_sql)
        end

        def self.finder_needs_type_condition?
          false
        end

        def self.ransackable_scopes(_auth_object = nil)
          %i(state_eq clinic_visit_clinic_id_eq)
        end

        ransacker :effective_date do
          effective_date_sort
        end
      end
    end

    class LetterQuery
      def initialize(q: nil)
        @q = q || {}
        @q[:s] ||= ["effective_date desc"]
      end

      def call
        search.result
      end

      def search
        @search ||= Letter.include(QueryableLetter).includes(:event).ransack(@q)
      end
    end
  end
end
