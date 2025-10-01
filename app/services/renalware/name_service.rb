# frozen_string_literal: true

# Map models to services and components. Works on class constants or instances.
module Renalware
  # This can be removed once Heroic integration is complete
  class Heroic::Events::HeroicEvent < Events::Event; end

  class NameService
    # We want to map to these base classes from their subclasses.
    # E.g. Letters::Letter::Completed maps to Letters::Letter...
    # And Events::Simple maps to Events::Event...
    # This list might not include all STI classes. Add them here as needed.
    STI_CLASSES = [
      Renalware::Heroic::Events::HeroicEvent, # Needs to be before Events::Event

      Renalware::Clinics::ClinicVisit,
      Renalware::Events::Event,
      Renalware::HD::Session,
      Renalware::Letters::Letter
    ].freeze

    def self.from_model(from, to:)
      klass = from.is_a?(Class) ? from : from.class
      base_class = STI_CLASSES.find { klass <= it }

      klass = base_class unless Object.const_defined?("#{klass}#{to}")

      "#{klass}#{to}".constantize
    end
  end
end
