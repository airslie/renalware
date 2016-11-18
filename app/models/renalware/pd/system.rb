require_dependency "renalware/pd"

module Renalware
  module PD
    class System < ActiveRecord::Base
      acts_as_paranoid

      validates :name, presence: true
      validates :pd_type, presence: true

      scope :for_apd, -> { for_pd_type("APD") }
      scope :for_capd, -> { for_pd_type("CAPD") }
      scope :for_pd_type, ->(pd_type) { where(pd_type: pd_type.to_s.upcase) }
    end
  end
end
