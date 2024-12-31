# TODO: when updating the UI, remember to use the 'with_deleted' scope so that
# if a plan is soft-deleted, it will still be displayed in low_clearance profiles that
# reference it, even though the plan will not be available for selection prospectively.
module Renalware
  module LowClearance
    class DialysisPlan < ApplicationRecord
      acts_as_paranoid
      validates :code, presence: true
      validates :name, presence: true
    end
  end
end
