module Renalware
  module Patients
    class NagComponent < ApplicationComponent
      include IconHelper

      attr_reader :definition, :patient, :nag

      delegate :title, :always_expire_cache_after_minutes, to: :definition
      delegate :value, :severity, :date, :sql_error, to: :nag

      with_collection_parameter :definition

      def initialize(patient:, definition:)
        @patient = patient
        @definition = definition
        @nag = definition.execute_sql_function_for(patient) || NullObject.instance
        super
      end

      def formatted_relative_link
        return if nag.relative_link.blank?

        @formatted_relative_link ||= begin
          path = definition.relative_link.gsub("/:id", "/#{patient.to_param}")
          path = "/#{path}" unless path.start_with?("/")
          path.chomp("/") # remove trailing slash
        end
      end

      def hint
        return if %i(none info).include?(severity)

        definition.hint
      end

      def cache?
        true
      end

      def always_expire_cache_after_seconds
        always_expire_cache_after_minutes.to_i * 60
      end

      # There is a caching issue here in that if the data returned by the nag SQL function has
      # changed then we do not invalidate the cache. I am not sure how we get around this - the nag
      # functions are expensive to call hence why we cache them, so no point including the returned
      # data in the cache_key. I think we will have to rely on the always_expire_cache_after_seconds
      # tripping over to invalidate the cache in this instance - or in an emergency a superadmin can
      # clear the application cache, or a developer can bump the updated_at date on the nag
      # definition (or touch the patient record in some way).
      def cache_key
        [
          patient.cache_key_with_version,
          definition.cache_key_with_version
        ].join("-")
      end

      # Note that nag could be nil if there was a SQL error executing the function.
      def render?
        return true if sql_error.present?
        return false unless nag
        return false if severity.blank? || severity.to_sym == :none
        return false unless definition.enabled

        true
      end
    end
  end
end
