module Renalware
  module Events
    class Type < ApplicationRecord
      include RansackAll

      self.table_name = "event_types"
      has_many(
        :alert_triggers,
        class_name: "EventTypeAlertTrigger",
        foreign_key: :event_type_id,
        dependent: :destroy
      )
      # Disabling the missing :dependent check here as I am not sure which option to chose for
      # a paranoid has_many (ie a soft-deleted Events::Type)
      # rubocop:disable Rails/HasManyOrHasOneDependent
      has_many(
        :events,
        class_name: "Events::Event",
        foreign_key: :event_type_id
      )
      # rubocop:enable Rails/HasManyOrHasOneDependent
      has_many(
        :subtypes,
        class_name: "Events::Subtype",
        inverse_of: :event_type,
        foreign_key: :event_type_id,
        dependent: :restrict_with_exception
      )
      belongs_to :category, class_name: "Events::Category"

      DEFAULT_EVENT_CLASS_NAME = "Renalware::Events::Simple".freeze

      acts_as_paranoid

      validates :name, presence: true, uniqueness: true
      validates :category_id, presence: true
      validates :slug,
                format: {
                  with: /\A[0-9a-z\-_]+\z/i,
                  case_sensitive: false
                },
                uniqueness: true,
                allow_nil: true

      scope :visible, -> { where(hidden: false) }

      # For use in migrations to reset the events_count counter cache column
      def self.reset_counters!
        find_each(&:reset_counters!)
      end

      def to_s = name

      def event_class_name
        super || DEFAULT_EVENT_CLASS_NAME
      end

      def event_class
        event_class_name.constantize
      end

      def reset_counters!
        self.class.reset_counters(id, :events)
      end

      delegate :subtypes?, to: :event_class
    end
  end
end
