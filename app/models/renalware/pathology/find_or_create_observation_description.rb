module Renalware
  module Pathology
    class FindOrCreateObservationDescription
      pattr_initialize [
        :observation!,
        :sender! # Renalware::Pathology::Sender
      ]
      delegate :identifier, :name, to: :observation

      # Finds an observation_description or creates one if not found.
      # Makes sure the description.measurement_unit, if unset, is set to the HL7 unit (eg mg) if
      # passed in. Also set the suggested_measurement_unit, which may be different to the
      # observation_description if was set incorrectly at some point.
      # The idea of suggested_measurement_unit is that it always updated dynamically if missing,
      # whereas measurement_unit is only updated if missing. This is to cope with the case where
      # the units of an OBX changes (eg by a factor of 10 as HB was a while back at KCH); in this
      # instance we only update the suggested_measurement_unit so its clear(ish) what the correct
      # value should be.
      def call
        desc = OBXMapping.observation_description_for(code: identifier, sender: sender)

        if desc.blank?
          desc = ObservationDescription.create!(
            code: identifier,
            name: name || identifier,
            measurement_unit: measurement_unit,
            suggested_measurement_unit: measurement_unit,
            created_by_sender: sender
          )
        elsif measurement_unit.present?
          desc.measurement_unit ||= measurement_unit
          desc.suggested_measurement_unit = measurement_unit
          desc.save! if desc.changed?
        end
        desc
      rescue ActiveRecord::RecordNotFound
        raise MissingObservationDescriptionError, code
      end

      private

      def measurement_unit
        @measurement_unit ||=
          observation.units.present? && MeasurementUnit.find_or_create_by!(name: observation.units)
      end

      # incoming_code alias  SendingFacility SendingApplication  maps_to
      # HBN           HBN    Facility1       Application1        HGB
      # HB            HB     Facility1       *                   HGB
      # HGB                                                      HGB
    end
  end
end
