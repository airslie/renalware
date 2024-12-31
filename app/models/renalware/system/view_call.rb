module Renalware
  module System
    class ViewCall < ApplicationRecord
      belongs_to :view_metadata,
                 counter_cache: :calls_count,
                 touch: :last_called_at
      belongs_to :user
    end
  end
end
