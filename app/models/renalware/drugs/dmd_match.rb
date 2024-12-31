module Renalware
  module Drugs
    class DMDMatch < ApplicationRecord
      include RansackAll
      belongs_to :drug
    end
  end
end
