# frozen_string_literal: true

module Renalware
  module Events
    class Type < ApplicationRecord
      self.table_name = "event_types"
      has_many(
        :alert_triggers,
        class_name: "EventTypeAlertTrigger",
        foreign_key: :event_type_id,
        dependent: :destroy
      )
      has_many(
        :events,
        class_name: "Events::Event",
        foreign_key: :event_type_id,
        dependent: :restrict_with_exception
      )
      has_many(
        :subtypes,
        class_name: "Events::Subtype",
        inverse_of: :event_type,
        foreign_key: :event_type_id,
        dependent: :restrict_with_exception
      )
      belongs_to :category, class_name: "Events::Category"

      DEFAULT_EVENT_CLASS_NAME = "Renalware::Events::Simple"

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

      enum editable_by_actor: {
        superadmins: "superadmins",
        all_admins: "all_admins",
        author_and_all_admins: "author_and_all_admins"
      }

      def to_s
        name
      end

      def event_class_name
        super || DEFAULT_EVENT_CLASS_NAME
      end

      def event_class
        event_class_name.constantize
      end

      # For use in migrations to reset the events_count counter cache column
      def self.reset_counters!
        all.find_each(&:reset_counters!)
      end

      def reset_counters!
        self.class.reset_counters(id, :events)
      end

      delegate :subtypes?, to: :event_class
    end
  end
end
