#
# A presenter which, for a patient, displays any HD preferences (for example when or where they
# have HD) that do not match their current HD profile.
#

module Renalware
  module HD
    class UnmetPreferencesPresenter
      include ActionView::Helpers
      COMMON_ATTRIBUTES = %i(schedule_definition other_schedule hospital_unit).freeze
      delegate(*COMMON_ATTRIBUTES, to: :hd_preference_set, prefix: :preferred, allow_nil: true)
      delegate(*COMMON_ATTRIBUTES, to: :hd_profile, prefix: :current, allow_nil: true)
      delegate(:notes, :entered_on, to: :hd_preference_set)
      delegate(:to_s, :to_param, :hd_profile, :hd_preference_set, to: :patient)

      def initialize(patient)
        @patient = patient
      end

      # Returns the HD::PreferenceSet setting if it differs from that in the HD::Profile
      # If the preference is unmet, wrap in a <b> tag. Yield the value so the template
      # has a chance to format it before it is wrapped.
      def preferred(attribute)
        value = public_send(:"preferred_#{attribute}")
        value = yield(value) if block_given?
        return value if preference_satisfied?(attribute)

        tag.b(value)
      end

      def preference_satisfied?(attribute)
        preferred = public_send(:"preferred_#{attribute}")
        current = public_send(:"current_#{attribute}")
        return true if preferred.blank? || preferred == current

        false
      end

      private

      attr_reader :patient
    end
  end
end
