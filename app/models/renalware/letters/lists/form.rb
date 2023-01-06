# frozen_string_literal: true

module Renalware
  module Letters
    module Lists
      # Form object to help us build and parse the appropriate filters for the
      # letters_lists controller #show action, where we display all/batch_printable letters etc.
      # For example, when displaying batchprintable letters we need to disable the enclosures
      # filter (setting it to No), and restrict the optionsin the letter states dropdown so only
      # Approved or Completed letters can be batch printed.
      # We delegate logic to an instance of a private class which is (or is a subclass of)
      # AllLetters.
      # If we need to add another filter type, create another sub class of AllLetters.
      class Form
        delegate_missing_to :@handler

        def initialize(named_filter:, params: {})
          @handler = create_filter_specific_object_to_handle_all_requests(named_filter, params)
        end

        def create_filter_specific_object_to_handle_all_requests(named_filter, params)
          handler_klass = "#{self.class.name}::#{named_filter.to_s.classify}Letters"
          handler_klass.constantize.new(params)
        end

        class AllLetters
          include ActiveModel::Model
          include Virtus::Model

          attribute :s, String # sort order, not really part of the form
          attribute :enclosures_present, Boolean
          attribute :notes_present, Boolean
          attribute :state_eq, Integer
          attribute :author_id_eq, Integer
          attribute :created_by_id_eq, Integer
          attribute :letterhead_id_eq, Integer
          attribute :page_count_in_array, Integer
          attribute :clinic_visit_clinic_id_eq, Integer

          def letter_state_options(states = Letters::Letter.states)
            states.map do |state|
              label = I18n.t(state.to_sym, scope: "enums.letter.for_receptionists.state")
              [label, state]
            end
          end

          def author_options
            @author_options ||= User.author.picklist
          end

          def typist_options
            @typist_options ||= User.picklist
          end

          def letterhead_options
            @letterhead_options ||= Letters::Letterhead.ordered
          end

          def clinic_visit_clinic_options
            @clinic_visit_clinic_options ||= Clinics::Clinic.order(:name).map { |cl|
              [cl.description, cl.id]
            }
          end

          def page_count_options
            [["1 or 2", "[1,2]"], ["3 or 4", "[3,4]"], ["5 or 6", "[5,6]"]]
          end

          def disabled_inputs
            []
          end

          def allow_blank_inputs
            [:state_eq, :page_count_in_array]
          end
        end

        class BatchPrintableLetters < AllLetters
          def initialize(params)
            super
            # These are the default values that must match the filters when the page is first
            # loaded, so the right results are displayed
            self.page_count_in_array ||= "[1,2]"
          end

          def letter_state_options
            super([:approved])
          end

          def disabled_inputs
            [:enclosures_present, :notes_present, :state_eq]
          end

          def allow_blank_inputs
            []
          end

          def enclosures_present
            false
          end

          def notes_present
            false
          end

          def state_eq
            @state_eq || :approved
          end
        end
      end
    end
  end
end
