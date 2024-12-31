module Renalware
  module UKRDC
    module TreatmentTimeline
      #
      # Re-generates the ukrdc_treatments for a patient from their modalities and other information.
      #
      class GenerateTimeline
        pattr_initialize :patient

        def call
          # RemapModelTableNamesToTheirPreparedEquivalents.new.call do
          Rails.logger.info "    Generating Treatment rows for modalities #{modality_names}"
          modalities.each do |modality|
            generator = GeneratorFactory.call(modality)
            generator.call
          end
          # end
        end

        private

        def modalities
          @modalities ||= begin
            patient
              .modalities
              .includes(:description, :created_by)
              .order(started_on: :asc, updated_at: :asc)
          end
        end

        def modality_names
          modalities.map { |mod| mod.description.name }.join("->")
        end
      end
    end
  end
end
