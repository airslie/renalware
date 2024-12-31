module Renalware
  module PD
    # Can't really replace DumbDelegator here with delegate_missing_to because, since this
    # class is used polymorphically, at some point #primary_key is called on the class, so we
    # would have to delegate that class method to the episode instance's class.. it gets a bit messy
    class PeritonitisEpisodePresenter < DumbDelegator
      def episode_types_summary
        return "Unknown" unless episode_types.any?

        episode_types.map do |type|
          type.peritonitis_episode_type_description.term
        end.join(", ")
      end

      # Required as DumbDelegator does not support
      def to_ary
        [self]
      end
    end
  end
end
