# frozen_string_literal: true

# FIXME: Make this class known to the NameService. Needed until Heroic integration
# is complete.
class Renalware::Heroic::Events::HeroicEvent < Renalware::Events::Event
end

# Map models to services and components. Works on class constants or instances.

module Renalware
  class NameService
    # We want to map to these base classes from their subclasses.
    # E.g. Letters::Letter::Completed maps to Letters::Letter...
    # And Events::Simple maps to Events::Event...
    # This list might not include all STI classes. Add them
    # here as needed.
    STI_CLASSES = [
      Renalware::Clinics::ClinicVisit,
      Renalware::Events::Event,
      Renalware::HD::Session,
      Renalware::Heroic::Events::HeroicEvent,
      Renalware::Letters::Letter
    ].freeze

    # from: Fully qualified model class to map from or an instance
    #       (e.g. Messaging::Internal::Message)
    # to: class to map to (e.g. TimelineRow)
    # keep_class: Whether to keep the class name in the resulting fully qualifed name
    #             (e.g. true => RemoteMonitoring::Registration::Detail)
    #             (     false => RemoteMonitoring::Detail)
    # name_service_spec.rb has some good examples.
    def self.from_model(from, to:, keep_class: false)
      klass = Renalware::Heroic::Events if from.is_a?(Renalware::Heroic::Events::HeroicEvent)
      klass = STI_CLASSES.find { from.is_a?(it) } unless keep_class
      klass ||= from.is_a?(Class) ? from : from.class
      parts = klass.name.split("::")
      parts = keep_class ? (parts << to) : (parts[0..-2] << to)
      parts.join("::").constantize
    end
  end
end
