module Renalware
  class Drugs::TradeFamilyClassification < ApplicationRecord
    belongs_to :drug
    belongs_to :trade_family

    scope :enabled, -> { where(enabled: true) }
  end
end
