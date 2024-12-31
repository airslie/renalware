require "active_support/concern"

module Renalware
  module OrderedScope
    extend ActiveSupport::Concern

    included do
      scope :ordered, -> { order(created_at: :desc) }
    end
  end
end
