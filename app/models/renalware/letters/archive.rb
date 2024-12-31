module Renalware
  module Letters
    class Archive < ApplicationRecord
      include Accountable

      belongs_to :letter, touch: true

      validates :content, presence: true
    end
  end
end
