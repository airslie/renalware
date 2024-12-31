module Renalware
  module HD
    class ModalityDescription < Modalities::Description
      def to_sym
        :hd
      end

      def augmented_name_for(patient)
        AugmentedModalityName.new(name, patient).to_s
      end

      # This class might be better as a presenter but leaving here for now.
      # #to_s returns e.g. "HD (HOSPCODE)" if patient's HD profile indicates they dialyse at
      # HOSPCODE, otherwise returns "HD".
      class AugmentedModalityName
        delegate :hd_profile, to: :patient, allow_nil: true
        delegate :hospital_unit, to: :hd_profile, allow_nil: true
        delegate :unit_code, to: :hospital_unit, allow_nil: true

        def initialize(default_name, patient)
          @patient = HD.cast_patient(patient)
          @default_name = default_name
        end

        def to_s
          return default_name if patient.blank? || unit_code.blank?

          "#{default_name} (#{unit_code})"
        end

        private

        attr_reader :patient, :default_name
      end
    end
  end
end
