module Renalware
  module Medications
    module Delivery
      class PurchaseOrderNumber
        SEQ_NAME = "renalware.medication_delivery_purchase_order_number_seq".freeze

        class << self
          def next_number
            result = ApplicationRecord.connection.execute("SELECT nextval('#{SEQ_NAME}');")
            result.first["nextval"]
          end

          def next
            [
              Renalware.config.medication_delivery_purchase_order_prefix,
              next_number
            ].join
          end
        end
      end
    end
  end
end
