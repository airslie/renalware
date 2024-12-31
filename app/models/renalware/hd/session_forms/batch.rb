module Renalware
  module HD
    module SessionForms
      class Batch < ApplicationRecord
        include Accountable

        enum :status, { queued: 0, processing: 10, awaiting_printing: 15, failure: 20, success: 30 }

        has_many(
          :items,
          dependent: :restrict_with_exception,
          class_name: "BatchItem"
        )

        def percent_complete
          ((items.where(status: :compiled).count.to_f / batch_items_count) * 100).ceil
        end
      end
    end
  end
end
