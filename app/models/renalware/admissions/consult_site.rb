module Renalware
  module Admissions
    class ConsultSite < ApplicationRecord
      validates :name, presence: true
    end
  end
end
