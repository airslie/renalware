module Renalware
  module System
    class UserFeedback < ApplicationRecord
      include RansackAll
      extend Enumerize
      validates :author, presence: true
      validates :category, presence: true
      validates :comment, presence: true

      belongs_to :author, class_name: "User"

      enumerize :category,
                in: %i(urgent_bug non_urgent_bug missing_feature general_comment),
                default: :general_comment
    end
  end
end
