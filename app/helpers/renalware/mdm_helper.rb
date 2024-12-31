module Renalware
  module MDMHelper
    def link_to_mdm(patient)
      MDMLink.new(patient).to_html
    end

    #
    # Create an html link to the MDM appropriate to the patient's current modality
    #
    class MDMLink
      include ActionView::Helpers
      include Renalware::Engine.routes.url_helpers

      def initialize(patient)
        @patient = patient
      end

      def path
        @path ||= begin
          return if modality_description.type.blank?

          case modality_description_symbol
          when :pd then patient_pd_mdm_path(patient)
          when :hd then patient_hd_mdm_path(patient)
          when :transplant then patient_transplants_mdm_path(patient)
          when :low_clearance then patient_low_clearance_mdm_path(patient)
          end
        end
      end

      def to_html
        link_to(mdm_name, path) if path
      end

      private

      attr_reader :patient

      delegate :name, to: :modality_description, prefix: true, allow_nil: true

      def modality_description
        current_modality = patient.current_modality || NullObject.instance
        current_modality.description
      end

      def mdm_name
        # "#{modality_description_name} MDM"
        "MDM"
      end

      def modality_description_symbol
        modality_description.becomes(modality_description.type.constantize).to_sym
      end
    end
  end
end
