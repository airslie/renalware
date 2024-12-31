module Renalware
  module Events
    class EventPdfPresenter < SimpleDelegator
      class DefaultHospitalCentreNotFoundError < StandardError; end
      class DefaultHospitalCentreNotSetError < StandardError; end

      delegate :info,
               :trust_name,
               :trust_caption,
               to: :hospital_centre, prefix: true, allow_nil: true

      delegate :external_document_type_code,
               :external_document_type_description,
               to: :event_type

      def approved_at
        created_at
      end

      def author
        created_by
      end

      private

      def hospital_centre
        @hospital_centre ||= begin
          centre = Renalware::Hospitals::Centre.find_by(code: default_hospital_centre_code)
          centre.presence || raise(DefaultHospitalCentreNotFoundError, default_hospital_centre_code)
        end
      end

      def default_hospital_centre_code
        Renalware.config.ukrdc_site_code.presence || raise(DefaultHospitalCentreNotSetError)
      end
    end
  end
end
