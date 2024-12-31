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

      class LCSDiffLeftCallbacks
        attr_accessor :output

        def initialize(output, options = {})
          @output = output
          @state  = :init

          @styles = {
            ins: "background: #9f9",
            del: "background:#fcc",
            eq: ""
          }
        end

        def to_html(element)
          element
        end

        # This will be called with both lines are the same
        def match(event)
          handle_entry(event.old_element, :eq)
        end

        # This will be called when there is a line in A that isn't in B
        def discard_a(event)
          handle_entry(event.old_element, :del)
        end

        # This will be called when there is a line in B that isn't in A
        def discard_b(event)
          handle_entry(event.new_element, :ins)
        end

        def handle_entry(element, state)
          return if state == :ins

          unless @state == state
            @output.push "</span>" unless @state == :init
            @state = state
            @output.push %Q(<span style="display: inline-block; #{@styles[state]}">)
          end

          @output.push(to_html(element))
        end

        private :handle_entry
      end

      class LCSDiffRightCallbacks
        attr_accessor :output

        def initialize(output, options = {})
          @output = output
          @state  = :init

          @styles = {
            ins: "background: #9f9",
            del: "background:#fcc",
            eq: ""
          }
        end

        def to_html(element)
          element
        end

        # This will be called with both lines are the same
        def match(event)
          handle_entry(event.old_element, :eq)
        end

        # This will be called when there is a line in A that isn't in B
        def discard_a(event)
          handle_entry(event.old_element, :del)
        end

        # This will be called when there is a line in B that isn't in A
        def discard_b(event)
          handle_entry(event.new_element, :ins)
        end

        def handle_entry(element, state)
          return if state == :del

          unless @state == state
            @output.push "</span>" unless @state == :init
            @state = state
            @output.push %Q(<span style="display: inline-block; #{@styles[state]}">)
          end

          @output.push(to_html(element))
        end

        private :handle_entry
      end
    end
  end
end
