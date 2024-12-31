module Renalware
  module Users
    module Groups
      class Membership < ApplicationRecord
        belongs_to(
          :group,
          foreign_key: :user_group_id,
          counter_cache: true,
          touch: true
        )
        belongs_to :user
        validates :group, presence: true
        validates :user, presence: true
      end
    end
  end
end
