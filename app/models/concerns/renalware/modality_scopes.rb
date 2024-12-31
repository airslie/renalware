module Renalware
  module ModalityScopes
    extend ActiveSupport::Concern

    class_methods do
      def with_current_modality_matching(modality_names)
        joins(:modality_descriptions)
          .where(
            modality_descriptions: {
              name: Array(modality_names)
            },
            modality_modalities: {
              state: "current",
              ended_on: nil
            }
          )
          .includes(:modality_description)
      end

      def with_current_modality_of_class(klass)
        joins(:modality_descriptions)
          .where(
            modality_descriptions: {
              type: klass.name
            },
            modality_modalities: {
              state: "current",
              ended_on: nil
            }
          )
          .includes(:modality_description)
      end
    end
  end
end
