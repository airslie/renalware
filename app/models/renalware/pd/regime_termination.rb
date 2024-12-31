module Renalware
  module PD
    class RegimeTermination < ApplicationRecord
      include Accountable

      belongs_to :regime, touch: true

      validates :terminated_on,
                timeliness: {
                  type: :date,
                  on_or_after: ->(termination) { termination.regime.start_date }
                }
    end
  end
end
