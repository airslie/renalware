module Renalware
  module Letters
    module Lists
      # Form object to help us build and parse the appropriate filters for the
      # letters_lists controller #show action, where we display all/batch_printable letters etc.
      # For example, when displaying batch-printable letters we need to disable the enclosures
      # filter (setting it to No), and restrict the options in the letter states dropdown so only
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
          include ActiveModel::Attributes

          attribute :s, :string # sort order, not really part of the form
          attribute :enclosures_present, :boolean
          attribute :notes_present, :boolean
          attribute :state_eq, :string
          attribute :gp_send_status_in, array: true, default: -> { [] }
          attribute :author_id_eq, :integer
          attribute :created_by_id_eq, :integer
          attribute :letterhead_id_eq, :integer
          attribute :page_count_in_array, :string
          attribute :clinic_visit_clinic_id_eq, :integer

          def letter_state_options(states = Letters::Letter.states)
            states.map do |state|
              label = I18n.t(state.to_sym, scope: "enums.letter.for_receptionists.state")
              [label, state]
            end
          end

          def gp_send_status_options
            @gp_send_status_options ||= Letter
              .gp_send_statuses
              .map { |key, val| [I18n.t(val, scope: "letters.gp_send_status"), key] }
          end

          def author_options      = @author_options ||= User.author.picklist
          def typist_options      = @typist_options ||= User.picklist
          def letterhead_options  = @letterhead_options ||= Letters::Letterhead.ordered
          def disabled_inputs     = []
          def allow_blank_inputs  = %i(state_eq gp_send_status_in page_count_in_array)
          def include_deleted     = false

          def clinic_visit_clinic_options
            @clinic_visit_clinic_options ||= Clinics::Clinic.order(:name).map { |cl|
              [cl.description, cl.id]
            }
          end

          def page_count_options
            [["1 or 2", "[1,2]"], ["3 or 4", "[3,4]"], ["5 or 6", "[5,6]"]]
          end
        end

        class BatchPrintableLetters < AllLetters
          # Because default option in the Rails attributes API does not honour the default
          # defined by a subclass (ie having the below declaration in AllLetters will not
          # resolve pre_selected_gp_send_status_options on this base class, but instead use the
          # class method on All Letters only..) we re-define the attribute here with a custom
          # default, which will always force gp_send_status_in to be an array of statuses that
          # excludes 'pending'
          attribute :gp_send_status_in,
                    array: true,
                    default: -> { pre_selected_gp_send_status_options }

          attribute :state_eq, :string, default: -> { :approved }

          # For Batch printing, hide letters where gp send_status is pending
          def self.pre_selected_gp_send_status_options
            return [] unless Renalware.config.send_gp_letters_over_mesh

            Letter.gp_send_statuses.fetch("pending") # Fail if 'pending' enum value goes missing ;)
            Letter.gp_send_statuses.reject { |key| key == "pending" }.keys
          end

          def initialize(params)
            super
            # These are the default values that must match the filters when the page is first
            # loaded, so the right results are displayed
            self.page_count_in_array ||= "[1,2]"
          end

          def letter_state_options = super([:approved])
          def disabled_inputs    = %i(enclosures_present notes_present state_eq gp_send_status_in)
          def allow_blank_inputs = %i(gp_send_status_in)
          def enclosures_present = false
          def notes_present      = false
          def state_eq           = :approved
        end

        class DeletedLetters < AllLetters
          def include_deleted = true
        end
      end
    end
  end
end
