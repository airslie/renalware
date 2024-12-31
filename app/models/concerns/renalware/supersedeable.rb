# Uses acts_as_paranoid to implement a means of deactivating an old and activating a
# new object such that there can only be one active object
# Enforcing only one active object requires an appropriate unique index to be created
# See https://github.com/rubysherpas/paranoia#unique-indexes
# Example migration:
#    add_column :hd_profiles, :deactivated_at, :datetime, index: true
#    add_column :hd_profiles, :active, :boolean, null: true, default: true
#    add_index :hd_profiles, [:active, :patient_id], unique: true
require "active_support/concern"

module Renalware
  module Supersedeable
    extend ActiveSupport::Concern

    included do
      class_eval do
        acts_as_paranoid column: :deactivated_at
      end

      def self.with_deactivated
        with_deleted
      end

      # Make a deep copy of the current object (self) into a successor, and update it with any
      # changes. Mark self as deleted.
      # Note 'update' callbacks will not be called on our successor until it has been saved first.
      # So we save the copy without any modifications first, so that on a subsequent update!
      # the update callbacks in the Accountable module will be called and if the
      # caller of this fn has supplied :by in attrs, it will cause the updated_by_id
      # column to be updated. Its a bit odd saving twice, but required here.
      # Without this 2 phase save, updated_by_id (if present) will remain at whatever it was
      # set at to in the object we are superseding.
      def supersede!(attrs = {})
        attrs = attrs.to_h unless attrs.is_a?(Hash)
        transaction do
          successor = dup
          destroy!
          successor.save!
          successor.update!(attrs) if attrs.any?
          successor
        end
      end

      def paranoia_restore_attributes
        {
          deactivated_at: nil,
          active: true
        }
      end

      def paranoia_destroy_attributes
        {
          deactivated_at: current_time_from_proper_timezone,
          active: nil
        }
      end
    end
  end
end
