module Renalware
  class ESRF < ActiveRecord::Base
    self.table_name = "esrf"

    belongs_to :patient
    belongs_to :prd_description

    def to_s
      [diagnosed_on, prd_description].compact.join(" ")
    end
  end
end
