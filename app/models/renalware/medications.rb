module Renalware
  module Medications
    def self.table_name_prefix = "medication_"

    module Delivery
      DRUG_TYPE_FILTERS = %i(esa immunosuppressant).freeze

      def self.table_name_prefix = "medication_delivery_"
    end
  end
end
