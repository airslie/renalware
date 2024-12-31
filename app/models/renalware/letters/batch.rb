module Renalware
  module Letters
    class Batch < ApplicationRecord
      include Accountable

      # TODO: I think these attributes are dead
      attr_accessor(
        :url,
        :enclosures_present,
        :notes_present,
        :state_eq,
        :author_id_eq,
        :created_by_id_eq,
        :letterhead_id_eq,
        :page_count_in_array,
        :s
      )

      enum :status, { queued: 0, processing: 10, awaiting_printing: 15, failure: 20, success: 30 }
      has_many(
        :items,
        dependent: :restrict_with_exception,
        class_name: "Renalware::Letters::BatchItem"
      )
      has_many(
        :letters,
        through: :items,
        class_name: "Renalware::Letters::Letter"
      )

      def percent_complete
        ((items.where(status: :compiled).count.to_f / batch_items_count) * 100).ceil
      end
    end
  end
end
