module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class ClinicVisitObservation < Rendering::Base
          pattr_initialize [:visit!, :method!, :i18n_key]

          def xml
            measurement = visit.public_send(method)
            return if measurement.blank? || measurement.to_f.zero?

            Observation.new(
              observed_at: visit.datetime,
              measurement: measurement,
              i18n_key: i18n_key || method
            ).xml
          end
        end
      end
    end
  end
end
