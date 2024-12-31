module Renalware
  module Events
    module Lists
      # Form object to help us build and parse the appropriate filters for the
      # events_lists controller
      class Form
        delegate_missing_to :@handler

        def initialize(named_filter:, params: {})
          @handler = create_filter_specific_object_to_handle_all_requests(named_filter, params)
        end

        def create_filter_specific_object_to_handle_all_requests(named_filter, params)
          handler_klass = "#{self.class.name}::#{named_filter.to_s.classify}Events"
          handler_klass.constantize.new(params)
        end

        class AllEvents
          include ActiveModel::Model
          include Virtus::Model

          attribute :s, String # sort order, not really part of the form
          attribute :event_type_id_eq, Integer
          attribute :created_by_id_eq, Integer
          attribute :created_at_gteq, Date
          attribute :created_at_lteq, Date

          def event_type_options
            Events::Type.order(:name).pluck(:name, :id)
          end

          def created_by_options
            User.excluding_system_user.picklist
          end
        end
      end
    end
  end
end
