module Renalware
  module Letters
    class SectionManager
      attr_reader :letter

      def initialize(letter)
        @letter = letter
      end

      delegate :patient, :letter_event, :letterhead, to: :letter

      # A letter has many sections, which could dynamically be set from:
      # 1. A Letter Event
      # 2. A Letter Topic
      def sections
        sections = (letter_event.part_classes + (letter.sections || [])).sort_by(&:position)
        filtered_classes = SectionClassFilter.new(
          sections: sections,
          include_pathology_in_letter_body: letterhead.include_pathology_in_letter_body?
        )
        filtered_classes.filter.map do |klass|
          klass.new(letter: letter, event: letter_event)
        end
      end

      def edit_sections_for_topic(topic: letter.topic)
        return [] if topic.nil?

        topic.sections.map { |section_class| section_class.new(letter: letter) }
      end

      # Given a hash of letter section classes (i.e. the class names for each Part that should be
      # included in the letter, where each Part is responsible for rendering a section of the
      # letter) and other options, this class filters out certain sections based on conditions,
      # for example if a site does not want pathology, the recent_pathology_results key is
      # removed from the hash.
      class SectionClassFilter
        pattr_initialize [:sections!, :include_pathology_in_letter_body!]

        def filter
          remove_recent_observations_section_if_no_pathology_required_in_body(sections)
        end

        private

        # Some sites may not require pathology in letters. This is determined by the boolean
        # #include_pathology_in_letter_body flag on the letterhead, which is site-specific.
        # TODO: It might be better to link the letterhead to the Hospitals::Site and
        # put the site-specific configuration in say a jsonb field on the Site.
        def remove_recent_observations_section_if_no_pathology_required_in_body(section_klasses)
          unless include_pathology_in_letter_body
            section_klasses = section_klasses.reject { |klass|
              klass.identifier == :recent_pathology_results
            }
          end
          section_klasses
        end
      end
    end
  end
end
