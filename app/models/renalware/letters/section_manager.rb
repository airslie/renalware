module Renalware
  module Letters
    class SectionManager
      attr_reader :letter

      def initialize(letter)
        @letter = letter
      end

      delegate :patient, :letter_event, :letterhead, to: :letter

      # Temporary code that just renders parts for all topics until
      # we refactor it.
      def parts
        parts = letter_event.part_classes
        filtered_classes = SectionClassFilter.new(
          parts:,
          include_pathology_in_letter_body: letterhead.include_pathology_in_letter_body?
        )
        filtered_classes.filter.map do |klass|
          klass.new(letter: letter)
        end
      end

      # Given a hash of letter section classes (i.e. the class names for each Part that should be
      # included in the letter, where each Part is responsible for rendering a section of the
      # letter) and other options, this class filters out certain sections based on conditions,
      # for example if a site does not want pathology, the recent_pathology_results key is
      # removed from the hash.
      class SectionClassFilter
        pattr_initialize [:parts!, :include_pathology_in_letter_body!]

        def filter
          remove_recent_observations_section_if_no_pathology_required_in_body(parts)
        end

        private

        # Some sites may not require pathology in letters. This is determined by the boolean
        # #include_pathology_in_letter_body flag on the letterhead, which is site-specific.
        # TODO: It might be better to link the letterhead to the Hospitals::Site and
        # put the site-specific configuration in say a jsonb field on the Site.
        def remove_recent_observations_section_if_no_pathology_required_in_body(part_classes)
          unless include_pathology_in_letter_body
            part_classes = part_classes.reject { |klass|
              klass.identifier == :recent_pathology_results
            }
          end
          part_classes
        end
      end
    end
  end
end
