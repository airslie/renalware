module Renalware
  module Sortable
    # Note!
    # !! Do not use this module when sorting things scoped to a patient or other parent !!
    # In those instances using eg
    #  acts_as_list scope: :patient_id
    # seems to be sufficient. For example the 'before_create :set_position' callback is
    # not needed if using a scope argument.
    #
    extend ActiveSupport::Concern

    # Assumes that the model has the #position attribute and adds 2 features to a model that
    # includes it:
    # 1. Set the :position to the next highest value when a new row is added. If the model has a
    #    position_sorting_scope scope or class method, this is used to narrow the range of records
    #    searched when finding the current max position
    # 2. Add ability to sort rows based on an array of ids.

    included do
      acts_as_list
      before_create :set_position
    end

    class_methods do
      # A controller #sort action might for instance invoke this class method on an object.
      # The array of ids are the model to sort, and sorting is done by updating each model's
      # position to reflect their place in the array.
      def sort(ids)
        Array(ids).each_with_index do |id, index|
          where(id: id).update_all(["position=?", index + 1])
        end
      end
    end

    # Invoked by the callback when a record is created to set the initial value of #position.
    # If no position_sorting_scope is defined on the model class, we set position to the max
    # position in the whole table. If position_sorting_scope is provided we use it to refine the
    # grouping and hence the max(position) found - for example to get the max position where
    # patient_id = 123
    #
    # Example scope in a model:
    #   scope :position_sorting_scope, ->(problem) { where(patient_id: problem.patient.id) }
    #
    def set_position
      return unless respond_to?(:position)

      scope = if self.class.respond_to?(:position_sorting_scope)
                self.class.position_sorting_scope(self)
              else
                self.class.default_scoped
              end
      self.position = (scope.maximum(:position) || 0) + 1
    end
  end
end
