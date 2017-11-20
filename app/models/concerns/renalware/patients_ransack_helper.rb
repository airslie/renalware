require "active_support/concern"

module Renalware
  module PatientsRansackHelper
    extend ActiveSupport::Concern
    UUID_REGEXP = /[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}/

    included do
      class_eval do
        scope :identity_match, ->(identity = 1) { where(sql_and_params(identity)) }
      end
    end

    class_methods do
      def ransackable_scopes(_auth = nil)
        %i(identity_match)
      end

      private

      def remove_spaces_if_nhs_number!(query)
        query.gsub!(/\s+/, "") if nhs_number?(query)
      end

      # Returns true if the argument with spaces removed is a 10 digit number
      def nhs_number?(str)
        return false unless str
        index = str.gsub(/\s+/, "") =~ /^\d{10}$/
        index.present?
      end

      def sanitize_query!(query)
        query.strip!
        query.tr!(",", " ")
        query.gsub!("  ", " ")
      end

      def sql_and_params(query)
        sanitize_query!(query)
        remove_spaces_if_nhs_number!(query)

        if query.include?(" ")
          [full_name_sql, full_name_params(query)]
        else
          [identity_sql(query), identity_params(query)]
        end
      end

      def identity_params(query)
        { fuzzy_term: "#{query}%", exact_term: query, ucase_term: query&.upcase }
      end

      def identity_sql(query)
        sql = <<-SQL.squish
          local_patient_id = :ucase_term OR
          local_patient_id_2 = :ucase_term OR
          local_patient_id_3 = :ucase_term OR
          local_patient_id_4 = :ucase_term OR
          local_patient_id_5 = :ucase_term OR
          external_patient_id = :exact_term OR
          nhs_number = :exact_term OR
          family_name ILIKE :fuzzy_term
        SQL
        sql += " OR ukrdc_external_id = :exact_term" if query_is_a_uuid?(query)
        sql
      end
      # rubocop:enable Metrics/MethodLength

      def query_is_a_uuid?(query)
        query.match(UUID_REGEXP)
      end

      def full_name_params(query)
        family_name, given_name = query.split(" ")
        { family_name: "#{family_name}%", given_name: "#{given_name}%" }
      end

      def full_name_sql
        <<-SQL.squish
          family_name ILIKE :family_name AND
          given_name ILIKE :given_name
        SQL
      end
    end
  end
end
