module Renalware
  module Clinical
    class ProfilePresenter
      attr_reader :patient, :params

      delegate :allergies, :document, to: :patient

      def initialize(patient:, params:)
        @params = params
        @patient = Clinical.cast_patient(patient)
      end

      def swabs
        @swabs ||= Renalware::Events::Swab
          .for_patient(patient)
          .includes([:event_type])
          .ordered
          .page(params[:page])
          .per(params.fetch(:per_page, 10))
      end

      def smoking_history
        history.smoking || NullObject.instance
      end

      def alcohol_history
        history.alcohol || NullObject.instance
      end

      def history
        document.history || NullObject.instance
      end

      %i(diabetes).each do |document_attribute|
        define_method(document_attribute) do
          document.send(document_attribute) || NullObject.instance
        end
      end

      def dry_weights
        @dry_weights ||= DryWeight.for_patient(patient).ordered.limit(5)
      end

      def body_compositions
        @body_compositions ||= begin
          BodyComposition
            .for_patient(patient)
            .includes([:modality_description, :assessor])
            .ordered
            .limit(5)
        end
      end
    end
  end
end
