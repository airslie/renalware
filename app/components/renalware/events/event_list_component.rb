module Renalware
  module Events
    # A generic view component for displaying a summarised list of events of a certain
    # type - for example Biopsy events - to add to a dashboard or MDM.
    # Once we have configurable dashboards and MDMs it should be possible to
    # drop this component onto a dashboard and configure the event class and perhaps
    # some other custom parameters, and at run time the dashboard is constructed
    # and will include the requested component. In this way you could choose to
    # add say list components which each display a different class of event.
    # Obviously some more thought needs to go into this but as a direction of
    # travel it has many advantages - for example a hospital can configure the default
    # dashboards and MDMs, perhaps depending on the user's role, but an individual user
    # could override and build their own.
    # Some parameters to think about when configuring an event component
    # - event class or description - where does the event_type fit in?
    # - the AR scope to use and whether this affects sorting
    # - the title displayed above the list of events - is this i18n, derived from the
    #   event type/class, or configured when the dashboard is designed?
    # - to what extent to the event partials affect display? We have these to help us
    #   build form inputs and display content in table cell/toggled cells, but is this flexible
    #   enough - e.g. is only have a Description HTML table column sufficient for displaying
    #   multiple custom event properties (defined in the event's document) or do we need to allow
    #   partials that control table structure?
    #
    # Perhaps a database-backed component configuration model could be passed into this component to
    # drive the display - eg hide_if_no_data of not.
    class EventListComponent < ApplicationComponent
      pattr_initialize [
        :patient!,
        :event_class!,
        limit: 6,
        hide_if_no_data: false, # if true and there are no events, nothing will be rendered
        title: nil,
        event_type_slug: nil
      ]

      attr_reader :warning

      # This assumes the event class has a scope called #ordered
      def events
        @events ||= CollectionPresenter.new(
          relation.includes(:created_by).ordered.limit(limit),
          Events::EventPresenter
        )
      end

      def event_count
        @event_count ||= events.length
      end

      def total_event_count
        @total_event_count ||= relation.count
      end

      def title
        @title || t(:title)
      end

      def description_column_title
        t(:description_column_title)
      end

      # There is the option to prevent anything from displaying if we expose the
      # render? method and return false
      def render?
        return true unless hide_if_no_data

        event_count > 0
      end

      private

      def relation
        @relation ||= begin
          if event_type_slug.present?
            event_type = Renalware::Events::Type.find_by(slug: event_type_slug)
            if event_type.present?
              event_type.events.for_patient(patient)
            else
              # We didn't find the event type! Do not error otherwise the rest of the page
              # is unusable. Think about outputting a message somewhere.
              @warning = "No event type found with slug '#{event_type_slug}'!"
              Renalware::Events::Event.none
            end
          else
            event_class.for_patient(patient)
          end
        end
      end

      def t(str)
        return if event_class&.name.blank?

        I18n.t(str, scope: event_class.name.underscore, default: "Description")
      end
    end
  end
end
