module Renalware
  module Pathology
    module Requests
      module FrequencyMethods
        extend ActiveSupport::Concern

        included do
          validates :frequency_type, presence: true
          validates :frequency_type, inclusion: { in: Frequency.all_names, allow_nil: true }
        end

        def frequency
          "Renalware::Pathology::Requests::Frequency::#{frequency_type}".constantize.new
        end
      end
    end
  end
end
