module Renalware
  module Renal
    class AKIAlertAction < ApplicationRecord
      include RansackAll
      validates :name, presence: true, uniqueness: true
      delegate :to_s, to: :name
    end
  end
end
