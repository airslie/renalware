module Renalware
  module Letters
    module Mailshots
      class Item < ApplicationRecord
        belongs_to :letter
        belongs_to :mailshot

        validates :letter, presence: true
        validates :mailshot, presence: true
      end
    end
  end
end
