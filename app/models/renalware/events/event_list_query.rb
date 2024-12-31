module Renalware
  module Events
    class EventListQuery
      attr_reader :params

      def initialize(params: {})
        @params = params
        @params[:s] = "created_at DESC" if @params[:s].blank?
      end

      def call
        search
          .result
          .eager_load(:event_type, :created_by, :patient)
          .ordered
      end

      def search
        @search ||= Event.include(Ransackers).ransack(params)
      end

      # Create ransackers to mixin to Event at runtime.
      # These for instance cast created_at to a date so that for instance the predicate
      # created_gteq excludes any time references - using created_gteq and created_lteq without
      # this creates SQL that cannot find an event on one day, because of the way Ransack adds
      # start of date and end of day times.
      module Ransackers
        extend ActiveSupport::Concern
        included do
          ransacker :created_at, type: :date do
            Arel.sql("DATE(events.created_at)")
          end

          ransacker :created_at, type: :date do
            Arel.sql("DATE(events.created_at)")
          end
        end
      end
    end
  end
end
