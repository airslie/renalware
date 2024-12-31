require "success"
require "failure"

module Renalware
  module Modalities
    class ChangePatientModality
      include Broadcasting

      attr_reader :patient, :user

      def initialize(patient:, user:)
        @patient = patient
        @user = user
      end

      # Accepts an existing (unsaved) :modality, or builds a new one from the options hash.
      # Terminates an existing current modality if once exists, and saves and make the new
      # modality current.
      # Example usage:
      #
      #   result = Modalities::ChangePatientModality
      #    .new(patient: patient, user: current_user)
      #    .call(
      #       description: HD::ModalityDescription.first!,
      #       started_on: Time.zone.now
      #    )
      #
      #  or
      #
      #  modality = patient.modalities.new(
      #    description: HD::ModalityDescription.first!,
      #    started_on: Time.zone.now
      #  )
      #  result = Modalities::ChangePatientModality
      #    .new(patient: patient, user: current_user)
      #    .call(modality: modality)
      #  )
      #
      # A Success or Failure result object is returned and the actual modality can be accessed on
      # the result.object property.
      #
      # We can broadcast events to inform listeners the modality has changed.
      # See #broadcast_modality_change_event_to_any_listeners for configuration.
      #
      def call(options)
        new_modality = parse_options(options)
        if new_modality.valid?
          make_new_modality_the_current_one(new_modality)
          broadcast_modality_change_event_to_any_listeners(new_modality)
          ::Success.new(new_modality)
        else
          ::Failure.new(new_modality)
        end
      end

      private

      def make_new_modality_the_current_one(new_modality)
        Modality.transaction do
          current_modality.terminate_by(user, on: new_modality.started_on)
          new_modality.save_by!(user)
        end
      end

      # Broadcast (using Wisper) an event to indicate the patient's current modality has changed,
      # This allows classes in other modules/parts of the application to take appropriate action.
      # For example the Letters module may want to terminate all patient prescriptions if the
      # modality changes to Death.
      #
      # The list of subscribers/listeners who will receive the message is set in the Broadcasting
      # module which we mix in above _provided_ the caller has chained the
      # #broadcasting_to_configured_subscribers method like so
      #
      # result = Modalities::ChangePatientModality
      #            .new(..)
      #            .broadcasting_to_configured_subscribers
      #            .call(..)
      #
      # If you wish to add more listeners and these are site/hospital-specific, this can be done
      # by configuring Renalware.config.broadcast_subscription_map. Be careful to append to rather
      # than replace the default entries in the hash map.
      # For example in a your applications config/initializers/renalware_core.rb, add:
      #  Renalware.configure do |config|
      #   map = config.broadcast_subscription_map
      #   map["Renalware::Modalities::ChangePatientModality"] << "SomeNamespace::SomeListenerClass"
      #  end
      #
      # When broadcasting events, if the event description has a #.to_sym e.g :hd or :death
      # then we use that in the name of the event, e.g. `patient_modality_changed_to_death`.
      # Otherwise, for more generic events we use `patient_modality_changed`.
      # I'm not sure this is a very consistent approach so may need to revisit.
      def broadcast_modality_change_event_to_any_listeners(new_modality)
        type = new_modality.description.to_sym
        method_name = type.nil? ? :patient_modality_changed : :"patient_modality_changed_to_#{type}"
        broadcast(
          method_name,
          patient: patient,
          modality: new_modality,
          actor: user
        )
      end

      def parse_options(options)
        return options[:modality] if options.key?(:modality)

        change_type = options.delete(:change_type_id) || ChangeType.default&.id
        options[:change_type_id] = change_type
        patient.modalities.new(options)
      end

      def current_modality
        patient.current_modality || NullObject.instance
      end
    end
  end
end
